using UnityEngine;
using System;
using System.Collections;

// Original reference: http://www.brechtos.com/hiding-or-disabling-inspector-properties-using-propertydrawers-within-unity-5/

namespace Poly
{
    [AttributeUsage(AttributeTargets.Field | AttributeTargets.Property | AttributeTargets.Class | AttributeTargets.Struct, Inherited = true)]
    public class ShowIfAttribute : PropertyAttribute
    {
        public string referenceField = "";
        public bool hideInInspector = false;
        public bool reverse = false;

        public ShowIfAttribute(string conditionalSourceField = "", bool hideInInspector = false, bool reverse = false)
        {
            this.referenceField = conditionalSourceField;
            this.hideInInspector = hideInInspector;
            this.reverse = reverse;
        }
    }



}
