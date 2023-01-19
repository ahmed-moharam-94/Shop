package com.example.pokedex;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import androidx.gridlayout.widget.GridLayout;
import android.widget.ImageView;
import android.widget.Toast;

import javax.xml.datatype.Duration;

public class MainActivity extends AppCompatActivity {
    // 0 for first player and 2 for thee second
    int activePlayer = 0;
    int[] gameState = {2,2,2,2,2,2,2,2,2};
    int[][] winningPositons = {{0,1,2}, {3,4,5}, {6,7,8}, {0,3,6}, {1,4,7}, {2,5,8}, {0,4,8}, {2,4,6}};
    boolean gameIsActive = true;

    Button resetButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void dropIn(View view) {
        ImageView diceImage = (ImageView) view;
        int tappedDice = Integer.parseInt(diceImage.getTag().toString());
        // set the right drawable file for the right player
        if ( gameState[tappedDice] == 2 && gameIsActive) {
            gameState[tappedDice] = activePlayer;
            diceImage.setTranslationY(-1500);
            if (activePlayer == 0) {
                diceImage.setImageResource(R.drawable.red_dot);
                activePlayer = 1;
            } else {
                diceImage.setImageResource(R.drawable.yellow_dot);
                activePlayer = 0;
            }
            diceImage.animate().translationYBy(1500).setDuration(300);
            //update game state
            for (int[] winningPosition : winningPositons) {
                if (gameState[winningPosition[0]] == gameState[winningPosition[1]] && gameState[winningPosition[1]] == gameState[winningPosition[2]] && gameState[winningPosition[0]] != 2) {
                    Toast.makeText(view.getContext(), "We have a winner", Toast.LENGTH_LONG).show();
                    gameIsActive = false;

                    resetButton = findViewById(R.id.button);
                    resetButton.setVisibility(View.VISIBLE);
                    resetButton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            resetGame();
                        }
                    });
                }
            }
        }
    }



    public void resetGame() {
        gameIsActive = true;
        activePlayer = 0;
        for (int i = 0; i < gameState.length; i++) {
            gameState[i] = 2;
        }
        // set button to invisivile
        resetButton.setVisibility(View.INVISIBLE);
        // set image drawable to null not invisible
        GridLayout gridLayout = findViewById(R.id.gridLayoutId);
        for (int i = 0; i < gridLayout.getChildCount(); i++) {
            ImageView imageView = (ImageView) gridLayout.getChildAt(i);
            imageView.setImageDrawable(null);
        }
    }
}
