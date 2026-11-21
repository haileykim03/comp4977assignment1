using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using MunicipalElectionsApi.Models;

namespace MunicipalElectionsApi.Data;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions options) : base(options) { }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<Municipality>().HasData(SeedData.GetMunicipalities());
        builder.Entity<Position>().HasData(SeedData.GetPositions());
        builder.Entity<Candidate>().HasData(SeedData.GetCandidates());
    }

    public DbSet<Municipality>? Municipalities { get; set; }
    public DbSet<Position>? Positions { get; set; }
    public DbSet<Candidate>? Candidates { get; set; }
    public DbSet<SavedCandidate>? SavedCandidates { get; set; }
}