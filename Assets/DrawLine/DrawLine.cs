using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawLine : MonoBehaviour {

	public Material m_material;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		GetMousePostion();
	}

	Vector2 GetMousePostion() {
		if (Input.GetMouseButton(0)) {
			Debug.Log(Input.mousePosition);
		}
		return Input.mousePosition;
	}

	void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture) {
		
		if (m_material != null) {
			Graphics.Blit(sourceTexture, destTexture, m_material); 
		} else {
			Graphics.Blit(sourceTexture, destTexture);  
		}
	}
}
