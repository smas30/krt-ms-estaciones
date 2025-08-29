package api;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;

import java.io.File;
import java.util.Collection;
import java.util.List;

public class ParallelRunner {

    public static void main(String[] args) {

        System.out.println("=== INICIANDO EJECUCION DE TEST: ===");

        Results results = Runner.path("classpath:api/")
                .outputCucumberJson(true)
                .reportDir("target")
                .tags("@clusterEnCeroClienteRequest")
                .parallel(1);
        generateReport(results.getReportDir(), results);
    }

    public static void generateReport(String karateOutputPath, Results results) {
        try {
            Collection<File> jsonFiles = FileUtils.listFiles(
                    new File(karateOutputPath), new String[]{"json"}, true);

            List<String> jsonPaths = jsonFiles.stream()
                    .filter(file -> file.getName().startsWith("api.") && file.getName().endsWith(".json"))
                    .map(File::getAbsolutePath)
                    .toList();

            if (jsonPaths.isEmpty()) {
                System.out.println("No se encontraron archivos JSON de reporte");
                return;
            }
            Configuration config = new Configuration(
                    new File("target/cucumber-reports"), "krt-ms-estaciones");
            config.setBuildNumber("1.0");

            // Agregar clasificaciones con información de tiempo
            config.addClassifications("Tiempo Total de ejecucion", results.getElapsedTime() + " ms");
            config.addClassifications("Features Ejecutados", String.valueOf(results.getFeaturesTotal()));
            config.addClassifications("Escenarios Ejecutados", String.valueOf(results.getScenariosTotal()));
            config.addClassifications("Escenarios Fallidos", String.valueOf(results.getFailCount()));

            ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
            reportBuilder.generateReports();

            System.out.println("Reporte HTML generado en: target/cucumber-reports/overview-features.html");
            System.out.println("Tiempo total de ejecucion: " + results.getElapsedTime() + " ms");
        } catch (Exception e) {
            System.err.println("Error generando reporte: " + e.getMessage());
        }
    }
}
