﻿using Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Interfaces
{
    public interface IProblemaFisicoRepository : IRepository<ProblemaFisico>
    {
        Task<List<ProblemaFisico>> ObtenerProblemasFisicosPorGanado(string idGanado);
        Task EliminarProblemaFisico(int idProblemaFisico);
        Task ActualizarProblemaFisico(ProblemaFisico problemaFisico);
    }
}
