using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using UNF2020.API.DatabaseModels;

namespace UNF2020.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlacementsController : ControllerBase
    {
        private readonly UNF2020Context _context;

        public PlacementsController(UNF2020Context context)
        {
            _context = context;
        }

        // GET: api/Placements
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Placement>>> GetPlacements([FromQuery] int pageSize = 100)
        {
            return await _context.Placement
                .OrderBy(x => x.PersonLastName)
                .Take(pageSize)
                .ToListAsync();
        }

        // GET: api/Placements/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Placement>> GetPlacement(int id)
        {
            var placement = await _context.Placement.FindAsync(id);

            if (placement == null)
            {
                return NotFound();
            }

            return placement;
        }

        // PUT: api/Placements/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPut("{id}")]
        public async Task<IActionResult> PutPlacement(int id, Placement placement)
        {
            if (id != placement.Id)
            {
                return BadRequest();
            }

            _context.Entry(placement).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!PlacementExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Placements
        // To protect from overposting attacks, enable the specific properties you want to bind to, for
        // more details, see https://go.microsoft.com/fwlink/?linkid=2123754.
        [HttpPost]
        public async Task<ActionResult<Placement>> PostPlacement(Placement placement)
        {
            _context.Placement.Add(placement);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (PlacementExists(placement.Id))
                {
                    return Conflict();
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetPlacement", new { id = placement.Id }, placement);
        }

        // DELETE: api/Placements/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Placement>> DeletePlacement(int id)
        {
            var placement = await _context.Placement.FindAsync(id);
            if (placement == null)
            {
                return NotFound();
            }

            _context.Placement.Remove(placement);
            await _context.SaveChangesAsync();

            return placement;
        }

        private bool PlacementExists(int id)
        {
            return _context.Placement.Any(e => e.Id == id);
        }
    }
}