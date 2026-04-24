/**
 * @author Michael Archbold (https://michaelarchbold.com)
 * @created 23/4/2026
 */
package com.distriqt.test.integrity
{
	import flash.utils.ByteArray;

	public class Base64
	{
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

		/**
		 * Encodes a ByteArray to URL-safe Base64 without padding.
		 */
		public static function encodeUrlSafe( data:ByteArray ):String
		{
			var output:String = "";
			var i:int = 0;

			data.position = 0;

			// Standard Base64 Encoding Logic
			while (i < data.length)
			{
				var byte1:int = data.readUnsignedByte();
				var hasByte2:Boolean = (i + 1 < data.length);
				var hasByte3:Boolean = (i + 2 < data.length);
				var byte2:int = hasByte2 ? data.readUnsignedByte() : 0;
				var byte3:int = hasByte3 ? data.readUnsignedByte() : 0;

				output += BASE64_CHARS.charAt( byte1 >> 2 );
				output += BASE64_CHARS.charAt( ((byte1 & 0x03) << 4) | (byte2 >> 4) );

				if (hasByte2)
				{
					output += BASE64_CHARS.charAt( ((byte2 & 0x0F) << 2) | (byte3 >> 6) );
				}
				if (hasByte3)
				{
					output += BASE64_CHARS.charAt( byte3 & 0x3F );
				}

				i += 3;
			}

			// Apply URL-safe transformations
			// 1. Replace '+' with '-'
			// 2. Replace '/' with '_'
			// 3. Remove padding (the logic above already omits '=' if bytes are missing)
			return output.replace( /\+/g, "-" ).replace( /\//g, "_" );
		}

	}
}
