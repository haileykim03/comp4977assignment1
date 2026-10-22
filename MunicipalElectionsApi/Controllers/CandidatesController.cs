using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

// Public endpoints for candidates (no login needed)
[Route("api/[controller]")]
[ApiController]
public class CandidatesController : ControllerBase
{
    // Database context, injected by ASP.NET (dependency injection)
    private readonly ApplicationDbContext _context;

    public CandidatesController(ApplicationDbContext context)
    {
        _context = context;
    }

    // GET: api/Candidates
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetCandidates()
    {
        // Include() also loads each candidate's position and municipality
        return await _context.Candidates!
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            .ToListAsync();
    }

    // GET: api/Candidates/1
    [HttpGet("{id}")]
    public async Task<ActionResult<Candidate>> GetCandidate(int id)
    {
        var candidate = await _context.Candidates!
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            .FirstOrDefaultAsync(c => c.CandidateId == id);

        if (candidate == null)
        {
            return NotFound();
        }

        return candidate;
    }

    // GET: api/Candidates/search?name=park
    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<Candidate>>> SearchCandidates(string? name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return BadRequest(new { message = "Please enter a name to search." });
        }

        return await _context.Candidates!
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            // Case-insensitive search by name
            .Where(c => c.Name!.ToLower().Contains(name.ToLower()))
            .ToListAsync();
    }
}