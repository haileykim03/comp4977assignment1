namespace MunicipalElectionsApi.Models;

public class Position
{
    public int PositionId { get; set; }
    public string? Name { get; set; }
    public int SeatsAvailable { get; set; }

    public int MunicipalityId { get; set; }
    public Municipality? Municipality { get; set; }
}