import os
import sys
from dataclasses import dataclass

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint

from src.exception import CustomException
from src.logger import logging


# ================= CONFIG =================
@dataclass
class ModelTrainerConfig:
    model_path: str = os.path.join("artifacts", "model.h5")
    epochs: int = 10              # 🔥 reduced (fast)
    learning_rate: float = 0.001


# ================= MODEL TRAINER =================
class ModelTrainer:
    def __init__(self):
        self.config = ModelTrainerConfig()

    def build_model(self, num_classes):
        try:
            model = Sequential([
                Conv2D(32, (3, 3), activation='relu', input_shape=(224, 224, 3)),
                MaxPooling2D(2, 2),

                Conv2D(64, (3, 3), activation='relu'),
                MaxPooling2D(2, 2),

                Conv2D(128, (3, 3), activation='relu'),
                MaxPooling2D(2, 2),

                Flatten(),

                Dense(128, activation='relu'),   # 🔥 reduced (fast)
                Dropout(0.5),

                Dense(num_classes, activation='softmax')
            ])

            model.compile(
                optimizer=Adam(learning_rate=self.config.learning_rate),
                loss='categorical_crossentropy',
                metrics=['accuracy']
            )

            logging.info("Model built successfully")
            return model

        except Exception as e:
            raise CustomException(e, sys)

    def initiate_model_trainer(self, train_data, test_data):
        try:
            logging.info("Starting model training")

            num_classes = len(train_data.class_indices)
            model = self.build_model(num_classes)

            os.makedirs(os.path.dirname(self.config.model_path), exist_ok=True)

            # ================= CALLBACKS =================
            early_stop = EarlyStopping(
                monitor='val_loss',
                patience=3,              # 🔥 faster stop
                restore_best_weights=True
            )

            checkpoint = ModelCheckpoint(
                self.config.model_path,
                monitor='val_accuracy',
                save_best_only=True,
                verbose=1
            )

            # ================= TRAIN =================
            history = model.fit(
                train_data,
                validation_data=test_data,
                epochs=self.config.epochs,
                callbacks=[early_stop, checkpoint]
            )

            # ================= EVALUATE =================
            loss, acc = model.evaluate(test_data)
            logging.info(f"Test Accuracy: {acc:.4f}")

            print(f"\n🔥 Final Accuracy: {acc:.4f}")
            print(f"✅ Model saved at: {self.config.model_path}")

            return model, history

        except Exception as e:
            raise CustomException(e, sys)


# ================= MAIN =================
if __name__ == "__main__":
    from src.Components.data_ingestion import DataIngestion
    from src.Components.data_transformation import DataTransformation

    try:
        print("🚀 Starting training pipeline...")

        # Data ingestion
        ingestion = DataIngestion()
        train_path, test_path = ingestion.initiate_data_ingestion()

        # Data transformation
        transform = DataTransformation(train_path, test_path)
        train_data, test_data = transform.initiate_data_transformation()

        # Model training
        trainer = ModelTrainer()
        model, history = trainer.initiate_model_trainer(train_data, test_data)

        print("🎉 Training completed successfully!")

    except Exception as e:
        print("❌ Error:", e)