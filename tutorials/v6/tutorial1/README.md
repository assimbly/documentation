# Tutorial 1: Debugging a Flow

In this tutorial you break a Flow on purpose and find out what went wrong. You learn where Assimbly Gateway 6 shows errors: the counters and alerts in the editor, the log viewer and the error details of a Flow that doesn't start.

**What you'll do:**

1. Clone a Flow
2. Change its Sink so it can't deliver files
3. Send a file and watch it fail
4. Find the full error in the log
5. Find out why a Flow doesn't start

It takes about 10 minutes.

## Before you start

* Complete the [Quick start](https://github.com/assimbly/gateway/wiki/quick-start). You need the Gateway running and the *TestFlow* that moves files from `C:/messages/in` to `C:/messages/out`.
* Make sure the folder `C:\messages\out2` does **not** exist. This tutorial relies on it being missing.

> On Linux or macOS, use `/home/<you>/messages/...` wherever this tutorial says `C:/messages/...`.

## Step 1: Clone the TestFlow

1. Go to **Flows → Manage**.
2. In the row of *TestFlow*, click **⋮** (*More actions*) and choose **Clone**.

![Clone the TestFlow](01-clone-flow.png)

The editor opens with a copy of *TestFlow*. Everything is copied except the name, which is empty.

## Step 2: Make the Sink fail

Change the copy so it can't deliver its files:

1. Next to **Flow name**, type `DebugFlow`.
2. Click the **Sink** on the canvas. Its settings open in the panel on the right. (Don't see the panel? Click **Show editor**.)
3. Change **Path** to `C:/messages/out2`.
4. Under **Options**, choose **Auto Create** in the list and turn the switch **Off**.

![Configure the Sink](02-configure-sink.png)

5. Click **Save**.

Normally the File component creates a missing folder for you. With **Auto Create** off it can't, so every file this Flow tries to deliver fails.

## Step 3: Send a file and watch it fail

1. Make sure *TestFlow* is stopped (see **Flows → Manage**). If it runs, it picks up the file before *DebugFlow* can.
2. In the editor of *DebugFlow*, click **Start**. The button turns green once the Flow is running.
3. Put a text file in the `in` folder:

   **Windows (PowerShell)**

   ```powershell
   "Hello Assimbly" | Out-File C:\messages\in\test.txt
   ```

   **Linux / macOS**

   ```bash
   echo "Hello Assimbly" > ~/messages/in/test.txt
   ```

The Source picks up the file, but the Sink can't store it. In the editor header the **Failed** counter goes up and a yellow **Alert** badge appears:

![The Flow fails](03-flow-failed.png)

4. Click the **Alert** badge. The *Alerts* panel lists the errors of this Flow:

![Alert details](04-alert-details.png)

`Cannot store file: C:\messages\out2\test.txt` tells you exactly what went wrong: the Sink can't write to the `out2` folder. Click **Clear** to remove the alerts once you've read them.

> **Where did my file go?** The Flow's **Error handler** takes care of failed messages. By default it writes the error to the Gateway log, after which the file is moved to the hidden `.camel` subfolder of the `in` folder, just like a file that was delivered. To do something else with failed messages, click **Error handler** in the editor toolbar.

## Step 4: Find the full error in the log

An alert is a one-line summary. The full details, such as the headers of the message and the stack trace, are in the Gateway log. You see the log in the terminal where you started the Gateway, or in your browser:

1. In the editor header of *DebugFlow*, click **Log**. A panel opens with the log of this Flow only.
2. Type `Cannot store file` in the filter box.

![The error in the log of the Flow](05-flow-log.png)

You find two entries:

* The first is written by the Flow's error handler. It shows the failed message: its headers, its body and the exception that was caught, followed by the stack trace.
* The second says **Failed delivery** and gives the exception: `GenericFileOperationFailedException: Cannot store file`.

> The panel shows the last entries of the log (the **Entries** field). Can't find the error? Raise **Entries**, or drop another file in the `in` folder and click **Refresh**. **Open in Log viewer** shows the same entries in **Administration → Log viewer**, where you can clear the Flow filter to see the whole Gateway log. On **Flows → Manage** you find the same panel under **⋮** → **View log**.

To fix the Flow, you would create the `out2` folder or turn **Auto Create** back on. Leave it broken for now, you need it in the next step.

## Step 5: Find out why a Flow doesn't start

Errors can also happen when a Flow starts. Let's force one:

1. In the editor of *DebugFlow*, click **Stop**.
2. Go to **Flows → Manage** and start *TestFlow* with the **▶** button in its row.
3. Click *DebugFlow* to open it, and click **Start**.

*DebugFlow* doesn't start. Instead a red **Error** badge appears in the header. Click it to see why:

![Error on start](06-start-error.png)

Both Flows read from the same folder, `C:/messages/in`. Only one Source at a time may listen to the same file endpoint, so the second Flow can't start: `Multiple consumers for the same endpoint is not allowed`.

When you're done, stop *TestFlow* in **Flows → Manage**.

## Summary

| Where | What it tells you |
|-------|-------------------|
| **Completed** / **Failed** counters | How many messages went through the Flow, and how many failed. |
| **Alert** badge | The latest errors of messages, one line each. |
| **Log** in the editor header (or **Administration → Log viewer**, or the terminal) | The full error, with the message headers and the stack trace. |
| **Error** badge | Why a Flow or one of its Steps didn't start. |

**Done!** You can now find out why a Flow fails. Continue with [Tutorial 2: Request/Reply](https://github.com/assimbly/gateway/wiki/tutorial6-request-reply).
