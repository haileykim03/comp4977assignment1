// app startup: registers the services (database, Identity, JWT, controllers)
// and sets up the request pipeline.
using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Web API controllers + OpenAPI document (used by Swagger UI)
builder.Services.AddControllers();
builder.Services.AddOpenApi();

// SQLite database through Entity Framework Core (connection string is in appsettings.json)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlite(connectionString));

// Identity: user accounts are stored in the database
builder.Services.AddIdentityCore<ApplicationUser>()
    .AddEntityFrameworkStores<ApplicationDbContext>();

// JWT: check the token sent in the "Authorization: Bearer <token>" header
var jwtKey = Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!);
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            IssuerSigningKey = new SymmetricSecurityKey(jwtKey)
        };
    });
// Enables the [Authorize] attribute on controllers
builder.Services.AddAuthorization();

var app = builder.Build();

// Swagger UI at /swagger to view and test the endpoints
app.MapOpenApi();
app.UseSwaggerUI(options =>
{
    options.SwaggerEndpoint("/openapi/v1.json", "Municipal Elections API");
});

app.UseHttpsRedirection();

// Order matters: read the JWT first, then check [Authorize]
app.UseAuthentication();
app.UseAuthorization();

// Connect the routes in the Controllers folder
app.MapControllers();

// Apply migrations automatically (creates the database and seed data)
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;

    var context = services.GetRequiredService<ApplicationDbContext>();
    context.Database.Migrate();
}

app.Run();