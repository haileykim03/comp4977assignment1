namespace MunicipalElectionsApi.Models;

public class Candidate
{
    public int CandidateId { get; set; }
    public string? Name { get; set; }
    public string? Biography { get; set; }
    public string? PhotoUrl { get; set; }
    public string? Website { get; set; }
    public string? Email { get; set; }

    public int PositionId { get; set; }
    public Position? Position { get; set; }

    public int MunicipalityId { get; set; }
    public Municipality? Municipality { get; set; }
}