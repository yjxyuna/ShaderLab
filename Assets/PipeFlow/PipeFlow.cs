using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PipeFlow : MonoBehaviour {

	Material m_material;

	// Use this for initialization
	void Start () {
		m_material = GetComponent<Renderer>().material;
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.A)) {
			Shader.EnableKeyword("pipe_flow");
//			m_material.EnableKeyword("pipe_flow");
		}

//		if (Input.GetKeyDown(KeyCode.R)) {
//			Shader.EnableKeyword("pipe_normal");
//		}

		if (Input.GetKeyDown(KeyCode.S)) {
			Shader.DisableKeyword("pipe_flow");
//			m_material.DisableKeyword("pipe_flow");
		}
	}
}
