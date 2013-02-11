﻿/*** ColorAdjustPlugin by Grant Skinner. Nov 3, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion.plugins {		import com.gskinner.motion.GTween;	import com.gskinner.geom.ColorMatrix;	import flash.filters.ColorMatrixFilter;	import com.gskinner.motion.plugins.IGTweenPlugin;		/**	* Plugin for GTween. Applies a color matrix filter to the target based on the "brightness", "contrast", "hue", and/or "hue" tween values.	* <br/><br/>	* If a color matrix filter does not already exist on the tween target, the plugin will create one.	* Note that this may conflict with other plugins that use filters. If you experience problems,	* try applying a color matrix filter to the target in advance to avoid this behaviour.	* <br/><br/>	* Supports the following <code>pluginData</code> properties:<UL>	* <LI> ColorAdjustEnabled: overrides the enabled property for the plugin on a per tween basis.	* <LI> ColorAdjustData: Used internally.	* </UL>	**/	public class ColorAdjustPlugin implements IGTweenPlugin {			// Static interface:		/** Specifies whether this plugin is enabled for all tweens by default. **/		public static var enabled:Boolean=true;				/** @private **/		protected static var instance:ColorAdjustPlugin;		/** @private **/		protected static var tweenProperties:Array = ["brightness","contrast","hue","saturation"];				/**		* Installs this plugin for use with all GTween instances.		**/		public static function install():void {			if (instance) { return; }			instance = new ColorAdjustPlugin();			GTween.installPlugin(instance,tweenProperties);		}			// Public methods:		/** @private **/		public function init(tween:GTween, name:String, value:Number):Number {			if (!((tween.pluginData.ColorAdjustEnabled == null && enabled) || tween.pluginData.ColorAdjustEnabled)) { return value; }						if (tween.pluginData.ColorAdjustData == null) {				// try to find an existing color matrix filter on the target:				var f:Array = tween.target.filters;				for (var i:uint=0; i<f.length; i++) {					if (f[i] is ColorMatrixFilter) {						var cmF:ColorMatrixFilter = f[i];						var o:Object = {index:i,ratio:NaN};												// save off the initial matrix:						o.initMatrix = cmF.matrix;												// save off the target matrix:						o.matrix = getMatrix(tween);												// store in pluginData for this tween for retrieval later:						tween.pluginData.ColorAdjustData = o;					}				}			}						// make up an initial value that will let us get a 0-1 ratio back later:			return tween.getValue(name)-1;		}				/** @private **/		public function tween(tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean):Number {			// don't run if we're not enabled:			if (!((tween.pluginData.ColorAdjustEnabled == null && enabled) || tween.pluginData.ColorAdjustEnabled)) { return value; }						// grab the tween specific data from pluginData:			var data:Object = tween.pluginData.ColorAdjustData;			if (data == null) { data = initTarget(tween); }						// only run once per tween tick, regardless of how many properties we're dealing with			// ex. don't run twice if both contrast and hue are specified, because we deal with them at the same time:			if (ratio == data.ratio) { return value; }			data.ratio = ratio;						// use the "magic" ratio we set up in init:			ratio = value-initValue;						// grab the filter:			var f:Array = tween.target.filters;			var cmF:ColorMatrixFilter = f[data.index] as ColorMatrixFilter;			if (cmF == null) { return value; }						// grab our init and target color matrixes:			var initMatrix:Array = data.initMatrix;			var targMatrix:Array = data.matrix;						// check if we're running backwards:			if (rangeValue < 0) {				// values were swapped.				initMatrix = targMatrix;				targMatrix = data.initMatrix;				ratio *= -1;			}						// grab the current color matrix, and tween it's values:			var matrix:Array = cmF.matrix;			var l:uint = matrix.length;			for (var i:uint=0; i<l; i++) {				matrix[i] = initMatrix[i]+(targMatrix[i]-initMatrix[i])*ratio;			}						// set the matrix back to the filter, and set the filters on the target:			cmF.matrix = matrix;			tween.target.filters = f;						// clean up if it's the end of the tween:			if (end) {				delete(tween.pluginData.ColorAdjustData);			}						// tell GTween not to use the default assignment behaviour:			return NaN;		}			// Private methods:		/** @private **/		protected function getMatrix(tween:GTween):ColorMatrix {			var brightness:Number = fixValue(tween.getValue("brightness"));			var contrast:Number = fixValue(tween.getValue("contrast"));			var saturation:Number = fixValue(tween.getValue("saturation"));			var hue:Number = fixValue(tween.getValue("hue"));			var mtx:ColorMatrix = new ColorMatrix();			mtx.adjustColor(brightness,contrast,saturation,hue);			return mtx;		}				/** @private **/		protected function initTarget(tween:GTween):Object {			var f:Array = tween.target.filters;			var mtx:ColorMatrix = new ColorMatrix();			f.push(new ColorMatrixFilter(mtx));			tween.target.filters = f;			var o:Object = {index:f.length-1, ratio:NaN};			o.initMatrix = mtx;			o.matrix = getMatrix(tween);			return tween.pluginData.ColorAdjustData = o;		}				/** @private **/		protected function fixValue(value:Number):Number {			return isNaN(value) ? 0 : value;		}					}}