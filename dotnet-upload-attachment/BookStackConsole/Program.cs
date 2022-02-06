using System;
using System.IO;
using System.Net;
using System.Net.Http;

namespace BookStackConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            // Check expected command arguments have been passed
            if (args.Length < 2)
            {
                Console.Error.WriteLine("Both <page_id> and <file_path> need to be provided!");
                Environment.Exit(1);
            }
            
            // Get our BookStack details from the environment
            var baseUrl = Environment.GetEnvironmentVariable("BS_URL") ?? "";
            var tokenId = Environment.GetEnvironmentVariable("BS_TOKEN_ID") ?? "";
            var tokenSecret = Environment.GetEnvironmentVariable("BS_TOKEN_SECRET") ?? "";
            baseUrl = baseUrl.TrimEnd('/');
            Console.WriteLine("base: " + baseUrl);

            // Get our target page ID and file path from command args.
            var pageId = args[0];
            var filePath = args[1];

            // Check our file exists
            if (!File.Exists(filePath))
            {
                Console.Error.WriteLine("Both <page_id> and <file_path> need to be provided!");
                Environment.Exit(1);
            }
            
            // Get our file name and read stream
            var fileName = Path.GetFileName(filePath);
            var fileStream = File.OpenRead(filePath);
            
            // Format our post data
            var postData = new MultipartFormDataContent();
            postData.Add(new StringContent(pageId), "uploaded_to");
            postData.Add(new StringContent(fileName), "name");
            postData.Add(new StreamContent(fileStream), "file", fileName);

            // Attempt to send up our file
            var client = new HttpClient();
            client.DefaultRequestHeaders.Add("Authorization", $"Token {tokenId}:{tokenSecret}");
            var respMessage = client.PostAsync(baseUrl + "/api/attachments", postData);
            
            // Write out a message to show success/failure along with response data
            Console.WriteLine("Response: " + respMessage.Result.Content.ReadAsStringAsync().Result);
            if (respMessage.IsCompletedSuccessfully && respMessage.Result.StatusCode == HttpStatusCode.OK)
            {
                Console.WriteLine("Attachment uploaded successfully!");
                Environment.Exit(0);
            }
            
            Console.WriteLine("Attachment failed to upload!");
            Environment.Exit(1);
        }
    }
}