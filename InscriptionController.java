@RestController
@RequestMapping("/api/inscription")
public class InscriptionController {

    @Autowired
    private InscriptionService inscriptionService;

    @GetMapping
    public List<Inscrit> getAllInscrits(@RequestParam(name = "classe", required = false) String classe) {
        if (classe != null) {
            return inscriptionService.getAllInscritsByClasse(classe);
        }
        return inscriptionService.getAllInscrits();
    }
}
