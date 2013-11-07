/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

/*
 * webOS.platform.* namespace
 * 
 * Platform identification of webOS variants
 *
 * LG webOS TV		webOS.platform.tv = true
 * Open webOS		webOS.platform.open = true
 * webOS 1.x-3.x	webOS.platform.legacy = true
 */

if(window.PalmSystem) {
	if(navigator.userAgent.indexOf("SmartTV")>-1) {
		webOS.platform = {tv: true};
	} else if(device.platformVersionMajor && device.platformVersionMinor &&
			parseInt(device.platformVersionMajor)==3 && 
			parseInt(device.platformVersionMinor)>0) {
		webOS.platform = {open: true};
	} else {
		webOS.platform = {legacy: true};
	}
}