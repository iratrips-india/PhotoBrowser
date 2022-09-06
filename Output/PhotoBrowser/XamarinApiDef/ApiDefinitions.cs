using System;
using Foundation;
using ObjCRuntime;
using PhotoBrowser;

namespace Xamarin.PhotoBrowser
{
	// @interface PhotoBrowser : NSObject
	[BaseType (typeof(NSObject))]
	interface PhotoBrowser
	{
		// @property (readonly, nonatomic, strong, class) PhotoBrowser * _Nonnull shared;
		[Static]
		[Export ("shared", ArgumentSemantic.Strong)]
		PhotoBrowser Shared { get; }

		// -(UIViewController * _Nonnull)showImagesWithUrls:(id)urls initialIndex:(NSInteger)initialIndex __attribute__((warn_unused_result));
		[Export ("showImagesWithUrls:initialIndex:")]
		UIViewController ShowImagesWithUrls (NSObject urls, nint initialIndex);
	}
}
