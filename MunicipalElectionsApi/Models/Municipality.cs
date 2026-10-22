namespace MunicipalElectionsApi.Models;

// A municipality that holds an election
public class Municipality
{
    public int MunicipalityId { get; set; }
    public string? Name { get; set; }
    public string? Province { get; set; }
    public DateTime ElectionDate { get; set; }
    public string? Description { get; set; }
    // URL of the logo image shown in the iOS app
    public string? LogoUrl { get; set; }
}