using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Data;

// IdentityDbContext = our tables + the Identity user tables
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        // Creates the Identity tables
        base.OnModelCreating(builder);

        // Sample data, added to the database by the migration (Code First seeding)
        builder.Entity<Municipality>().HasData(SeedData.GetMunicipalities());
        builder.Entity<Position>().HasData(SeedData.GetPositions());
        builder.Entity<Candidate>().HasData(SeedData.GetCandidates());
    }

    // One DbSet = one table
    public DbSet<Municipality>? Municipalities { get; set; }
    public DbSet<Position>? Positions { get; set; }
    public DbSet<Candidate>? Candidates { get; set; }
    public DbSet<SavedCandidate>? SavedCandidates { get; set; }
}