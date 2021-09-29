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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;

import org.apache.commons.exec.ExecuteStreamHandler;
import org.apache.commons.io.IOUtils;

/**
 * @author eric.wittmann@gmail.com
 */
final class ExecutorOutputHandler implements ExecuteStreamHandler {

    private final ByteArrayOutputStream cmdOutput;
    private InputStream is;
    private InputStream err;

    /**
     * Constructor.
     * @param cmdOutput
     */
    ExecutorOutputHandler() {
        this.cmdOutput = new ByteArrayOutputStream();
    }

    @Override
    public void stop() throws IOException {
        IOUtils.copy(is, cmdOutput);
        IOUtils.copy(err, cmdOutput);
    }

    @Override
    public void start() throws IOException {
        this.cmdOutput.reset();
    }

    @Override
    public void setProcessOutputStream(InputStream is) throws IOException {
        this.is = is;
    }

    @Override
    public void setProcessInputStream(OutputStream os) throws IOException {
    }

    @Override
    public void setProcessErrorStream(InputStream is) throws IOException {
        this.err = is;
    }

    public String getOutput() {
        return this.cmdOutput.toString(StandardCharsets.UTF_8);
    }
}