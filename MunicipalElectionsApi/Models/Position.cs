namespace MunicipalElectionsApi.Models;

// An elected position in a municipality
public class Position
{
    public int PositionId { get; set; }
    public string? Name { get; set; }
    // How many people will be elected for this position
    public int SeatsAvailable { get; set; }

    // Foreign key + navigation property to the municipality
    public int MunicipalityId { get; set; }
    public Municipality? Municipality { get; set; }
}