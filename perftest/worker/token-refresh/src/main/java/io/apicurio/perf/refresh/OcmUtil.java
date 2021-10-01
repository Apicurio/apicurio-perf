/*
 * Copyright 2021 Red Hat
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.apicurio.perf.refresh;

import java.io.File;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;

/**
 * @author eric.wittmann@gmail.com
 */
public class OcmUtil {

    /**
     * @param ocmPath
     * @param ocmUrl
     * @param offlineToken
     */
    public static Token getToken(String ocmPath, String ocmUrl, String offlineToken) {
        ExecutorOutputHandler outputHandler = new ExecutorOutputHandler();
        try {
            // Login first.
            String cmd = ocmPath + " login --url=OCM_URL --token=\"TOKEN\"".replace("OCM_URL", ocmUrl).replace("TOKEN", offlineToken);

            CommandLine cmdLine = CommandLine.parse(cmd);
            DefaultExecutor executor = new DefaultExecutor();
            executor.setWorkingDirectory(new File("/apps/bin"));
            executor.execute(cmdLine);

            // If that worked, get the token!
            cmd = ocmPath + " token";
            cmdLine = CommandLine.parse(cmd);
            executor.setStreamHandler(outputHandler);
            executor.execute(cmdLine);

            String jwt = outputHandler.getOutput().trim();

            Token token = new Token();
            token.setJwt(jwt);
            token.setExpiresOn(JwtUtil.extractExpiration(jwt));
            return token;
        } catch (Exception e) {
            String error = outputHandler.getOutput();
            throw new RuntimeException(error, e);
        }
    }

}
