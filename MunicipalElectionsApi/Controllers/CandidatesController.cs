using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class CandidatesController : CityScopedController
{
    public CandidatesController(ApplicationDbContext context) : base(context) { }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Candidate>>> GetCandidates(string? city)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        return await _context.Candidates!
            .Where(c => c.MunicipalityId == municipality!.MunicipalityId)
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            .OrderBy(c => c.PositionId).ThenBy(c => c.Name)
            .ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Candidate>> GetCandidate(int id, string? city)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        var candidate = await _context.Candidates!
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            .FirstOrDefaultAsync(c => c.CandidateId == id && c.MunicipalityId == municipality!.MunicipalityId);

        if (candidate == null)
        {
            return NotFound(new { message = "Candidate not found in this municipality." });
        }

        return candidate;
    }

    [HttpGet("search")]
    public async Task<ActionResult<IEnumerable<Candidate>>> SearchCandidates(string? city, string? name)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        if (string.IsNullOrWhiteSpace(name))
        {
            return BadRequest(new { message = "Please enter a name to search." });
        }

        return await _context.Candidates!
            .Where(c => c.MunicipalityId == municipality!.MunicipalityId)
            .Include(c => c.Position)
            .Include(c => c.Municipality)
            .Where(c => c.Name!.ToLower().Contains(name.ToLower()))
            .ToListAsync();
    }
}
