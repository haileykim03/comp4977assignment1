using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

[Authorize]
[Route("api/[controller]")]
[ApiController]
public class SavedCandidatesController : ControllerBase
{
    private readonly ApplicationDbContext _context;

    public SavedCandidatesController(ApplicationDbContext context)
    {
        _context = context;
    }

    private string GetUserId()
    {
        return User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<SavedCandidate>>> GetSavedCandidates()
    {
        string userId = GetUserId();

        return await _context.SavedCandidates!
            .Where(s => s.UserId == userId)
            .Include(s => s.Candidate).ThenInclude(c => c!.Position)
            .Include(s => s.Candidate).ThenInclude(c => c!.Municipality)
            .ToListAsync();
    }

    [HttpPost]
    public async Task<ActionResult<SavedCandidate>> PostSavedCandidate(SaveCandidateModel model)
    {
        string userId = GetUserId();

        var candidate = await _context.Candidates!.FindAsync(model.CandidateId);
        if (candidate == null)
        {
            return NotFound();
        }

        bool alreadySaved = await _context.SavedCandidates!
            .AnyAsync(s => s.UserId == userId && s.CandidateId == model.CandidateId);
        if (alreadySaved)
        {
            return Conflict(new { message = "This candidate is already in your voting guide." });
        }

        var saved = new SavedCandidate
        {
            UserId = userId,
            CandidateId = model.CandidateId,
            DateSaved = DateTime.Now
        };

        _context.SavedCandidates!.Add(saved);
        await _context.SaveChangesAsync();

        return saved;
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSavedCandidate(int id)
    {
        string userId = GetUserId();

        var saved = await _context.SavedCandidates!
            .FirstOrDefaultAsync(s => s.SavedCandidateId == id && s.UserId == userId);

        if (saved == null)
        {
            return NotFound();
        }

        _context.SavedCandidates!.Remove(saved);
        await _context.SaveChangesAsync();

        return NoContent();
    }
}