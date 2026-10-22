package com.example.navirail_app

import android.os.Bundle
import android.view.View
import android.widget.FrameLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.ar.core.Pose
import com.google.ar.core.TrackingState
import com.google.ar.sceneform.AnchorNode
import com.google.ar.sceneform.FrameTime
import com.google.ar.sceneform.Node
import com.google.ar.sceneform.Scene
import com.google.ar.sceneform.math.Vector3
import com.google.ar.sceneform.rendering.Color
import com.google.ar.sceneform.rendering.MaterialFactory
import com.google.ar.sceneform.rendering.ShapeFactory
import com.google.ar.sceneform.ux.ArFragment

class ArNavigationActivity : AppCompatActivity() {

    companion object {
        const val EXTRA_PATH = "extra_path"
    }

    private lateinit var arFragment: ArFragment
    private var arrowsPlaced = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val container = FrameLayout(this).apply {
            id = View.generateViewId()
        }

        val overlayText = TextView(this).apply {
            textSize = 16f
            setTextColor(android.graphics.Color.WHITE)
            setPadding(32, 64, 32, 32)
            elevation = 10f
        }

        val root = FrameLayout(this).apply {
            addView(container, FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            ))
            addView(overlayText, FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.WRAP_CONTENT
            ))
        }

        setContentView(root)

        val path = intent.getStringArrayListExtra(EXTRA_PATH) ?: arrayListOf()
        overlayText.text = if (path.isNotEmpty()) {
            "Path: " + path.joinToString(" → ")
        } else {
            "No path received"
        }

        arFragment = ArFragment()
        supportFragmentManager
            .beginTransaction()
            .add(container.id, arFragment)
            .commit()
        // Ensure the fragment transaction is applied and the ARSceneView is created
        supportFragmentManager.executePendingTransactions()

        val sceneView = arFragment.arSceneView
        val scene = sceneView?.scene ?: return

        scene.addOnUpdateListener { frameTime: FrameTime ->
            val frame = sceneView.arFrame ?: return@addOnUpdateListener

            if (frame.camera.trackingState != TrackingState.TRACKING) return@addOnUpdateListener
            if (arrowsPlaced || path.isEmpty()) return@addOnUpdateListener

            arrowsPlaced = true

            MaterialFactory.makeOpaqueWithColor(this, Color(android.graphics.Color.CYAN))
                .thenAccept { material ->
                    // Simple arrow-like box for each path step, placed in front of the user
                    val boxRenderable = ShapeFactory.makeCube(
                        Vector3(0.1f, 0.1f, 0.1f),
                        Vector3.zero(),
                        material
                    )

                    val session = arFragment.arSceneView.session ?: return@thenAccept

                    path.forEachIndexed { index, _ ->
                        val distance = 0.5f + index * 0.4f
                        val pose = frame.camera.pose.compose(
                            Pose.makeTranslation(0f, -0.1f, -distance)
                        )

                        val anchor = session.createAnchor(pose)
                        val anchorNode = AnchorNode(anchor).apply {
                            setParent(arFragment.arSceneView.scene)
                        }

                        val node = Node().apply {
                            setParent(anchorNode)
                            renderable = boxRenderable
                        }
                    }
                }
        }
    }
}
