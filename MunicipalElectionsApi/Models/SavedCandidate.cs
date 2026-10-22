using System.Text.Json.Serialization;

namespace MunicipalElectionsApi.Models;

// One candidate saved to a user's personal voting guide
public class SavedCandidate
{
    public int SavedCandidateId { get; set; }

    // The user who saved it (an ASP.NET Identity user)
    public string? UserId { get; set; }
    [JsonIgnore] // never send user account data in the JSON
    public ApplicationUser? User { get; set; }

    // The saved candidate
    public int CandidateId { get; set; }
    public Candidate? Candidate { get; set; }

    // When it was added to the guide
    public DateTime DateSaved { get; set; }
}