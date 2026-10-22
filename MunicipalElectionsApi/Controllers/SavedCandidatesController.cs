using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Data;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Controllers;

[Authorize] // a valid JWT is required for every action in this controller
[Route("api/[controller]")]
[ApiController]
public class SavedCandidatesController : ControllerBase
{
    // Database context, injected by ASP.NET (dependency injection)
    private readonly ApplicationDbContext _context;

    public SavedCandidatesController(ApplicationDbContext context)
    {
        _context = context;
    }

    // The logged-in user's id is read from the token
    private string GetUserId()
    {
        return User.FindFirst(ClaimTypes.NameIdentifier)!.Value;
    }

    // GET: api/SavedCandidates
    [HttpGet]
    public async Task<ActionResult<IEnumerable<SavedCandidate>>> GetSavedCandidates()
    {
        string userId = GetUserId();

        // Only this user's saved candidates, with the candidate details
        return await _context.SavedCandidates!
            .Where(s => s.UserId == userId)
            .Include(s => s.Candidate).ThenInclude(c => c!.Position)
            .Include(s => s.Candidate).ThenInclude(c => c!.Municipality)
            .ToListAsync();
    }

    // POST: api/SavedCandidates      body: { "candidateId": 3 }
    [HttpPost]
    public async Task<ActionResult<SavedCandidate>> PostSavedCandidate(SaveCandidateModel model)
    {
        string userId = GetUserId();

        // 1. Make sure the candidate exists
        var candidate = await _context.Candidates!.FindAsync(model.CandidateId);
        if (candidate == null)
        {
            return NotFound();
        }

        // 2. Do not save the same candidate twice
        bool alreadySaved = await _context.SavedCandidates!
            .AnyAsync(s => s.UserId == userId && s.CandidateId == model.CandidateId);
        if (alreadySaved)
        {
            return Conflict(new { message = "This candidate is already in your voting guide." });
        }

        // 3. Save it for the logged-in user
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

    // DELETE: api/SavedCandidates/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteSavedCandidate(int id)
    {
        string userId = GetUserId();

        // Users can only delete their own saved candidates
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