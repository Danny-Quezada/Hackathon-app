﻿using Data.Repository;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Models.Entities;
using Models.Interfaces;

namespace GanadoControlAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class InseminacionController : ControllerBase
    {
        private readonly IInseminacionRepository inseminacionRepository;

        public InseminacionController(IInseminacionRepository inseminacionRepository)
        {
            this.inseminacionRepository = inseminacionRepository;
        }

        [HttpPost]
        public async Task<IActionResult> Post([FromForm] Inseminacion inseminacion)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            if(inseminacion is null)
            {
                return BadRequest("El objeto Inseminacion es nulo");
            }
            try
            {
                return Ok(inseminacionRepository.Insertar(inseminacion));
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al insertar inseminación: {ex.Message}");
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                return Ok(await inseminacionRepository.EliminarInseminacion(id));
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }
    }
}
