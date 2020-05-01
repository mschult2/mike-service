using System;
using System.IO;
using System.ServiceProcess;

namespace MikeSvc
{
    class Program
    {
        static void Main(string[] args)
        {
            using (var service = new MikeService())
            {
                ServiceBase.Run(service);
            }
        }
    }

    internal class MikeService : ServiceBase
    {

        public MikeService()
        {
            ServiceName = "MikeService";
        }

        protected override void OnStart(string[] args)
        {
            try
            {
                Console.WriteLine($"{DateTime.Now} started.{Environment.NewLine}");
            }
            catch
            {
                // Trigger service recovery
                Environment.Exit(-1);
            }
        }

        protected override void OnStop()
        {
            try
            {
                Console.WriteLine($"{DateTime.Now} stopped.{Environment.NewLine}");
            }
            catch
            {
                // Trigger service recovery
                Environment.Exit(-1);
            }
        }

        private static string CheckFileExists()
        {
            string dirname = @"c:\MikeService";
            string filename = Path.Combine(dirname, "MikeService.log");

            Directory.CreateDirectory(dirname);

            if (!File.Exists(filename))
            {
                File.Create(filename);
            }

            return filename;
        }
    }
}