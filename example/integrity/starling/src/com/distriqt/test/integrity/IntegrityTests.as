/**
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		17/01/2025
 */
package com.distriqt.test.integrity
{
	import air.security.Digest;

	import com.distriqt.extension.googleplay.integrity.Integrity;

	import flash.utils.ByteArray;

	import starling.display.Sprite;

	/**
	 */
	public class IntegrityTests extends Sprite
	{
		public static const TAG:String = "";

		private var _l:ILogger;

		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}


		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//

		public function IntegrityTests( logger:ILogger )
		{
			_l = logger;
			try
			{
				log( "Integrity Supported: " + Integrity.isSupported );
				if (Integrity.isSupported)
				{
					log( "Integrity Version:   " + Integrity.service.version );
				}

			}
			catch (e:Error)
			{
				trace( e );
			}
		}


		////////////////////////////////////////////////////////
		//  
		//

		public function prepare():void
		{
			Integrity.service.prepareIntegrityToken(
					Config.PROJECT_NUMBER,
					function ():void
					{
						log( "Integrity API prepared successfully" );
					},
					function ( error:Error ):void
					{
						log( "Error preparing integrity token: " + error.message );
					}
			);
		}

		public function requestToken():void
		{
			var requestData:Object = {
				"user_id"  : "user123",
				"action"   : "purchase_item",
				"timestamp": new Date().time
			};
			var requestHash:String = generateRequestHash( JSON.stringify( requestData ) );

			Integrity.service.requestIntegrityToken(
					requestHash,
					function ( token:String ):void
					{
						log( "Integrity token received: " + token );
					},
					function ( error:Error ):void
					{
						log( "Error requesting integrity token: " + error.message );
					}
			);
		}

		public function generateRequestHash( data:String ):String
		{
			var inputBytes:ByteArray = new ByteArray();
			inputBytes.writeUTFBytes( data );
			var hash:ByteArray = Digest.hash( Digest.SHA256, inputBytes );
			return Base64.encodeUrlSafe( hash );
		}


		public function requestClassicToken():void
		{
			var nonce:String = "";
			Integrity.service.requestIntegrityClassicToken(
					Config.PROJECT_NUMBER,
					nonce,
					function ( token:String ):void
					{
						log( "Classic integrity token received: " + token );
					},
					function ( error:Error ):void
					{
						log( "Error requesting classic integrity token: " + error.message );
					}
			);
		}

	}
}
