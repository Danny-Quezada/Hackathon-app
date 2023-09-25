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
        public IActionResult Post([FromBody] Inseminacion inseminacion)
        {
            inseminacionRepository.Insertar(inseminacion);
            return Created("Creado", true);
        }
    }
}