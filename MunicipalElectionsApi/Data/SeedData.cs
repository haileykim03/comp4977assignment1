using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Data;

public class SeedData
{
    public static List<Municipality> GetMunicipalities()
    {
        var electionDay = new DateTime(2026, 10, 17);

        List<Municipality> municipalities = new List<Municipality>() {
            new Municipality() { MunicipalityId = 1, Name = "Pitt Meadows", Province = "BC", ElectionDate = electionDay,
                Description = "A small city known for its farmland and rivers.", LogoUrl = Picture("Pitt Meadows") },
            new Municipality() { MunicipalityId = 2, Name = "Maple Ridge", Province = "BC", ElectionDate = electionDay,
                Description = "A growing city near Golden Ears Provincial Park.", LogoUrl = Picture("Maple Ridge") },
            new Municipality() { MunicipalityId = 3, Name = "Burnaby", Province = "BC", ElectionDate = electionDay,
                Description = "A large city in Metro Vancouver, home to BCIT.", LogoUrl = Picture("Burnaby") },
        };

        return municipalities;
    }

    public static List<Position> GetPositions()
    {
        List<Position> positions = new List<Position>() {
            new Position() { PositionId = 1, Name = "Mayor", SeatsAvailable = 1, MunicipalityId = 1 },
            new Position() { PositionId = 2, Name = "Councillor", SeatsAvailable = 5, MunicipalityId = 1 },
            new Position() { PositionId = 3, Name = "School Trustee", SeatsAvailable = 2, MunicipalityId = 1 },
            new Position() { PositionId = 4, Name = "Mayor", SeatsAvailable = 1, MunicipalityId = 2 },
            new Position() { PositionId = 5, Name = "Councillor", SeatsAvailable = 6, MunicipalityId = 2 },
            new Position() { PositionId = 6, Name = "School Trustee", SeatsAvailable = 5, MunicipalityId = 2 },
            new Position() { PositionId = 7, Name = "Mayor", SeatsAvailable = 1, MunicipalityId = 3 },
            new Position() { PositionId = 8, Name = "Councillor", SeatsAvailable = 8, MunicipalityId = 3 },
            new Position() { PositionId = 9, Name = "School Trustee", SeatsAvailable = 7, MunicipalityId = 3 },
        };

        return positions;
    }

    public static List<Candidate> GetCandidates()
    {
        List<Candidate> candidates = new List<Candidate>() {
            new Candidate() { CandidateId = 1, Name = "Daniel Okafor", Biography = "Small business owner focused on local jobs.",
                PhotoUrl = Picture("Daniel Okafor"), Website = "https://example.com", Email = "daniel@example.com", PositionId = 1, MunicipalityId = 1 },
            new Candidate() { CandidateId = 2, Name = "Grace Whitfield", Biography = "Retired nurse who wants better services for seniors.",
                PhotoUrl = Picture("Grace Whitfield"), Website = "https://example.com", Email = "grace@example.com", PositionId = 1, MunicipalityId = 1 },
            new Candidate() { CandidateId = 3, Name = "Priya Sandhu", Biography = "Civil engineer who wants safer roads and crosswalks.",
                PhotoUrl = Picture("Priya Sandhu"), Website = "https://example.com", Email = "priya@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 4, Name = "Hannah Cho", Biography = "Former teacher's aide who wants smaller class sizes.",
                PhotoUrl = Picture("Hannah Cho"), Website = "https://example.com", Email = "hannah@example.com", PositionId = 3, MunicipalityId = 1 },
            new Candidate() { CandidateId = 5, Name = "Robert Tanaka", Biography = "Two-term councillor focused on affordable housing.",
                PhotoUrl = Picture("Robert Tanaka"), Website = "https://example.com", Email = "robert@example.com", PositionId = 4, MunicipalityId = 2 },
            new Candidate() { CandidateId = 6, Name = "Elena Rossi", Biography = "Community organizer focused on public safety.",
                PhotoUrl = Picture("Elena Rossi"), Website = "https://example.com", Email = "elena@example.com", PositionId = 4, MunicipalityId = 2 },
            new Candidate() { CandidateId = 7, Name = "Samuel Brooks", Biography = "Firefighter who wants more parks and trails.",
                PhotoUrl = Picture("Samuel Brooks"), Website = "https://example.com", Email = "samuel@example.com", PositionId = 5, MunicipalityId = 2 },
            new Candidate() { CandidateId = 8, Name = "Liam OConnor", Biography = "School counsellor who supports student mental health.",
                PhotoUrl = Picture("Liam OConnor"), Website = "https://example.com", Email = "liam@example.com", PositionId = 6, MunicipalityId = 2 },
            new Candidate() { CandidateId = 9, Name = "Jennifer Park", Biography = "Urban planner who wants homes near SkyTrain stations.",
                PhotoUrl = Picture("Jennifer Park"), Website = "https://example.com", Email = "jennifer@example.com", PositionId = 7, MunicipalityId = 3 },
            new Candidate() { CandidateId = 10, Name = "Michael Novak", Biography = "Entrepreneur who wants faster business permits.",
                PhotoUrl = Picture("Michael Novak"), Website = "https://example.com", Email = "michael@example.com", PositionId = 7, MunicipalityId = 3 },
            new Candidate() { CandidateId = 11, Name = "Sofia Martinez", Biography = "Climate scientist who wants more bike lanes.",
                PhotoUrl = Picture("Sofia Martinez"), Website = "https://example.com", Email = "sofia@example.com", PositionId = 8, MunicipalityId = 3 },
            new Candidate() { CandidateId = 12, Name = "Olivia Bennett", Biography = "Librarian who wants a library in every school.",
                PhotoUrl = Picture("Olivia Bennett"), Website = "https://example.com", Email = "olivia@example.com", PositionId = 9, MunicipalityId = 3 },
            new Candidate() { CandidateId = 13, Name = "Arjun Mehta", Biography = "Accountant who wants a balanced city budget.",
                PhotoUrl = Picture("Arjun Mehta"), Website = "https://example.com", Email = "arjun@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 14, Name = "Fiona MacLeod", Biography = "Farmer who wants to protect agricultural land.",
                PhotoUrl = Picture("Fiona MacLeod"), Website = "https://example.com", Email = "fiona@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 15, Name = "Kevin Byrne", Biography = "Paramedic focused on emergency response times.",
                PhotoUrl = Picture("Kevin Byrne"), Website = "https://example.com", Email = "kevin@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 16, Name = "Mei Chen", Biography = "Youth soccer coach who wants more sports fields.",
                PhotoUrl = Picture("Mei Chen"), Website = "https://example.com", Email = "mei@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 17, Name = "Owen Gallagher", Biography = "Transit advocate who wants better bus service.",
                PhotoUrl = Picture("Owen Gallagher"), Website = "https://example.com", Email = "owen@example.com", PositionId = 2, MunicipalityId = 1 },
            new Candidate() { CandidateId = 18, Name = "Aisha Karim", Biography = "Parent volunteer who wants healthy school lunches.",
                PhotoUrl = Picture("Aisha Karim"), Website = "https://example.com", Email = "aisha@example.com", PositionId = 3, MunicipalityId = 1 },
            new Candidate() { CandidateId = 19, Name = "Lucas Fontaine", Biography = "French immersion teacher who supports language programs.",
                PhotoUrl = Picture("Lucas Fontaine"), Website = "https://example.com", Email = "lucas@example.com", PositionId = 3, MunicipalityId = 1 },
            new Candidate() { CandidateId = 20, Name = "Nina Petrova", Biography = "Architect who wants walkable neighbourhoods.",
                PhotoUrl = Picture("Nina Petrova"), Website = "https://example.com", Email = "nina@example.com", PositionId = 5, MunicipalityId = 2 },
            new Candidate() { CandidateId = 21, Name = "Diego Alvarez", Biography = "Restaurant owner focused on the local economy.",
                PhotoUrl = Picture("Diego Alvarez"), Website = "https://example.com", Email = "diego@example.com", PositionId = 5, MunicipalityId = 2 },
            new Candidate() { CandidateId = 22, Name = "Julia Kowalski", Biography = "Environmental scientist who wants cleaner rivers.",
                PhotoUrl = Picture("Julia Kowalski"), Website = "https://example.com", Email = "julia@example.com", PositionId = 5, MunicipalityId = 2 },
            new Candidate() { CandidateId = 23, Name = "Hamid Rahimi", Biography = "Software developer who wants coding in every school.",
                PhotoUrl = Picture("Hamid Rahimi"), Website = "https://example.com", Email = "hamid@example.com", PositionId = 6, MunicipalityId = 2 },
            new Candidate() { CandidateId = 24, Name = "Marcus Delgado", Biography = "Housing co-op manager focused on rental homes.",
                PhotoUrl = Picture("Marcus Delgado"), Website = "https://example.com", Email = "marcus@example.com", PositionId = 8, MunicipalityId = 3 },
            new Candidate() { CandidateId = 25, Name = "Amara Nwosu", Biography = "Public health nurse who wants more community clinics.",
                PhotoUrl = Picture("Amara Nwosu"), Website = "https://example.com", Email = "amara@example.com", PositionId = 8, MunicipalityId = 3 },
            new Candidate() { CandidateId = 26, Name = "Tom Hargreaves", Biography = "Retired police officer focused on safer streets.",
                PhotoUrl = Picture("Tom Hargreaves"), Website = "https://example.com", Email = "tom@example.com", PositionId = 8, MunicipalityId = 3 },
            new Candidate() { CandidateId = 27, Name = "Eleanor Whitfield", Biography = "Former principal who wants more school counsellors.",
                PhotoUrl = Picture("Eleanor Whitfield"), Website = "https://example.com", Email = "eleanor@example.com", PositionId = 9, MunicipalityId = 3 },
        };

        return candidates;
    }

    private static string Picture(string name)
    {
        return "https://ui-avatars.com/api/?size=256&name=" + Uri.EscapeDataString(name);
    }
}