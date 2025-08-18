package util;

import com.fasterxml.jackson.databind.JsonNode;
import com.github.fge.jackson.JsonLoader;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.main.JsonSchema;
import com.github.fge.jsonschema.main.JsonSchemaFactory;

import java.util.Random;

public class JsonSchemaUtil {

    public static boolean isValid(String exptSch, String jsonResp) throws Exception {
        if (exptSch.isEmpty() && jsonResp.isEmpty()) {
            return true;
        }
        JsonNode schemaNode = JsonLoader.fromString(exptSch);
        JsonSchemaFactory factory = JsonSchemaFactory.byDefault();
        JsonSchema jsonSchema = factory.getJsonSchema(schemaNode);
        JsonNode jsonNode = JsonLoader.fromString(jsonResp);
        ProcessingReport report = jsonSchema.validate(jsonNode);
        return report.isSuccess();
    }


    public static int generateRandomNumber(){
        Random random = new Random();
        return 1 + random.nextInt(200);
    }
}
