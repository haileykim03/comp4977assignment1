using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.JsonWebTokens;
using Microsoft.IdentityModel.Tokens;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

// Register and login.
// Login returns a JWT that the iOS app sends with protected requests.
[Route("api/[controller]")]
[ApiController]
public class AuthController : ControllerBase
{
    // UserManager (ASP.NET Identity) creates users and checks passwords
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IConfiguration _config;

    public AuthController(UserManager<ApplicationUser> userManager, IConfiguration config)
    {
        _userManager = userManager;
        _config = config;
    }

    // POST: api/Auth/register
    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterModel model)
    {
        // The email is also used as the user name
        var user = new ApplicationUser
        {
            UserName = model.Email,
            Email = model.Email,
            Name = model.Name
        };

        // Identity hashes the password and saves the user
        var result = await _userManager.CreateAsync(user, model.Password!);

        if (!result.Succeeded)
        {
            // e.g. email already taken, or password too weak
            return BadRequest(new { message = result.Errors.First().Description });
        }

        return Ok(new { message = "Account created." });
    }

    // POST: api/Auth/login
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginModel model)
    {
        // Find the user, then check the password
        var user = await _userManager.FindByEmailAsync(model.Email!);

        if (user == null || !await _userManager.CheckPasswordAsync(user, model.Password!))
        {
            return Unauthorized(new { message = "Invalid email or password." });
        }

        // Send back the token (plus name and email for the Profile screen)
        return Ok(new { token = CreateToken(user), name = user.Name, email = user.Email });
    }

    // Builds the JWT: header + payload (claims) + signature
    private string CreateToken(ApplicationUser user)
    {
        // Secret key from appsettings.json (Jwt:Key)
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]!));

        var tokenInfo = new SecurityTokenDescriptor
        {
            // Claims stored in the token: the user's id and email
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(ClaimTypes.Email, user.Email!)
            }),
            // The token is valid for 1 day
            Expires = DateTime.UtcNow.AddDays(1),
            SigningCredentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
        };

        return new JsonWebTokenHandler().CreateToken(tokenInfo);
    }
}