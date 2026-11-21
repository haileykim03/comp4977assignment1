using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814

namespace MunicipalElectionsApi.Data.Migrations
{
    public partial class A2SeedUpdate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Candidates",
                columns: new[] { "CandidateId", "Biography", "Email", "MunicipalityId", "Name", "PhotoUrl", "PositionId", "Website" },
                values: new object[,]
                {
                    { 13, "Accountant who wants a balanced city budget.", "arjun@example.com", 1, "Arjun Mehta", "https://ui-avatars.com/api/?size=256&name=Arjun%20Mehta", 2, "https://example.com" },
                    { 14, "Farmer who wants to protect agricultural land.", "fiona@example.com", 1, "Fiona MacLeod", "https://ui-avatars.com/api/?size=256&name=Fiona%20MacLeod", 2, "https://example.com" },
                    { 15, "Paramedic focused on emergency response times.", "kevin@example.com", 1, "Kevin Byrne", "https://ui-avatars.com/api/?size=256&name=Kevin%20Byrne", 2, "https://example.com" },
                    { 16, "Youth soccer coach who wants more sports fields.", "mei@example.com", 1, "Mei Chen", "https://ui-avatars.com/api/?size=256&name=Mei%20Chen", 2, "https://example.com" },
                    { 17, "Transit advocate who wants better bus service.", "owen@example.com", 1, "Owen Gallagher", "https://ui-avatars.com/api/?size=256&name=Owen%20Gallagher", 2, "https://example.com" },
                    { 18, "Parent volunteer who wants healthy school lunches.", "aisha@example.com", 1, "Aisha Karim", "https://ui-avatars.com/api/?size=256&name=Aisha%20Karim", 3, "https://example.com" },
                    { 19, "French immersion teacher who supports language programs.", "lucas@example.com", 1, "Lucas Fontaine", "https://ui-avatars.com/api/?size=256&name=Lucas%20Fontaine", 3, "https://example.com" },
                    { 20, "Architect who wants walkable neighbourhoods.", "nina@example.com", 2, "Nina Petrova", "https://ui-avatars.com/api/?size=256&name=Nina%20Petrova", 5, "https://example.com" },
                    { 21, "Restaurant owner focused on the local economy.", "diego@example.com", 2, "Diego Alvarez", "https://ui-avatars.com/api/?size=256&name=Diego%20Alvarez", 5, "https://example.com" },
                    { 22, "Environmental scientist who wants cleaner rivers.", "julia@example.com", 2, "Julia Kowalski", "https://ui-avatars.com/api/?size=256&name=Julia%20Kowalski", 5, "https://example.com" },
                    { 23, "Software developer who wants coding in every school.", "hamid@example.com", 2, "Hamid Rahimi", "https://ui-avatars.com/api/?size=256&name=Hamid%20Rahimi", 6, "https://example.com" },
                    { 24, "Housing co-op manager focused on rental homes.", "marcus@example.com", 3, "Marcus Delgado", "https://ui-avatars.com/api/?size=256&name=Marcus%20Delgado", 8, "https://example.com" },
                    { 25, "Public health nurse who wants more community clinics.", "amara@example.com", 3, "Amara Nwosu", "https://ui-avatars.com/api/?size=256&name=Amara%20Nwosu", 8, "https://example.com" },
                    { 26, "Retired police officer focused on safer streets.", "tom@example.com", 3, "Tom Hargreaves", "https://ui-avatars.com/api/?size=256&name=Tom%20Hargreaves", 8, "https://example.com" },
                    { 27, "Former principal who wants more school counsellors.", "eleanor@example.com", 3, "Eleanor Whitfield", "https://ui-avatars.com/api/?size=256&name=Eleanor%20Whitfield", 9, "https://example.com" }
                });

            migrationBuilder.UpdateData(
                table: "Positions",
                keyColumn: "PositionId",
                keyValue: 2,
                column: "SeatsAvailable",
                value: 5);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "Candidates",
                keyColumn: "CandidateId",
                keyValue: 27);

            migrationBuilder.UpdateData(
                table: "Positions",
                keyColumn: "PositionId",
                keyValue: 2,
                column: "SeatsAvailable",
                value: 6);
        }
    }
}
