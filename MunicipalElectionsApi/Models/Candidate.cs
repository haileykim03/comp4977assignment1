namespace MunicipalElectionsApi.Models;

// A person running for a position in a municipality
public class Candidate
{
    public int CandidateId { get; set; }
    public string? Name { get; set; }
    public string? Biography { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Website { get; set; }
    public string? Email { get; set; }

    // Foreign key + navigation property to the position
    public int PositionId { get; set; }
    public Position? Position { get; set; }

    // Foreign key + navigation property to the municipality
    public int MunicipalityId { get; set; }
    public Municipality? Municipality { get; set; }
}