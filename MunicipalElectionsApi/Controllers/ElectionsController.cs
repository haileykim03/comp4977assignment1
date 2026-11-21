using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;

namespace MunicipalElectionsApi.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class ElectionsController : CityScopedController
{
    public ElectionsController(ApplicationDbContext context) : base(context) { }

    [HttpGet]
    public async Task<IActionResult> GetElection(string? city)
    {
        var (municipality, error) = await FindCityAsync(city);
        if (error != null)
        {
            return error;
        }

        var m = municipality!;
        int id = m.MunicipalityId;

        var positions = await _context.Positions!
            .Where(p => p.MunicipalityId == id)
            .OrderBy(p => p.PositionId)
            .Select(p => new
            {
                p.PositionId,
                p.Name,
                p.SeatsAvailable,
                CandidateCount = _context.Candidates!.Count(c => c.PositionId == p.PositionId)
            })
            .ToListAsync();

        return Ok(new
        {
            m.MunicipalityId,
            m.Name,
            m.Province,
            m.ElectionDate,
            m.Description,
            m.LogoUrl,
            Positions = positions
        });
    }
}
