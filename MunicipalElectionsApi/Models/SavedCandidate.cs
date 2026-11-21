using System.Text.Json.Serialization;

namespace MunicipalElectionsApi.Models;

public class SavedCandidate
{
    public int SavedCandidateId { get; set; }

    public string? UserId { get; set; }
    [JsonIgnore]
    public ApplicationUser? User { get; set; }

    public int CandidateId { get; set; }
    public Candidate? Candidate { get; set; }

    public DateTime DateSaved { get; set; }
}