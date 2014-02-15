// WARNING
//
// This file has been generated automatically by Xamarin Studio to store outlets and
// actions made in the UI designer. If it is removed, they will be lost.
// Manual changes to this file may not be handled correctly.
//
using MonoTouch.Foundation;
using System.CodeDom.Compiler;

namespace ParseiOSStarterProject
{
	[Register ("MainViewController")]
	partial class MainViewController
	{
		[Outlet]
		MonoTouch.UIKit.UIBarButtonItem createButton { get; set; }

		[Outlet]
		MonoTouch.UIKit.UITabBarItem myListItems { get; set; }

		[Outlet]
		MonoTouch.UIKit.UINavigationItem navigationItem { get; set; }

		[Outlet]
		MonoTouch.UIKit.UIBarButtonItem settingsButton { get; set; }

		[Outlet]
		MonoTouch.UIKit.UITabBarItem snetItems { get; set; }

		[Outlet]
		MonoTouch.UIKit.UITabBar tabBar { get; set; }

		[Outlet]
		MonoTouch.UIKit.UITabBarItem unreadItems { get; set; }
		
		void ReleaseDesignerOutlets ()
		{
			if (tabBar != null) {
				tabBar.Dispose ();
				tabBar = null;
			}

			if (navigationItem != null) {
				navigationItem.Dispose ();
				navigationItem = null;
			}

			if (settingsButton != null) {
				settingsButton.Dispose ();
				settingsButton = null;
			}

			if (createButton != null) {
				createButton.Dispose ();
				createButton = null;
			}

			if (unreadItems != null) {
				unreadItems.Dispose ();
				unreadItems = null;
			}

			if (myListItems != null) {
				myListItems.Dispose ();
				myListItems = null;
			}

			if (snetItems != null) {
				snetItems.Dispose ();
				snetItems = null;
			}
		}
	}
}
