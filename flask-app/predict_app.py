
import base64
import numpy as np
import io
import keras
from keras import backend as K
from keras.models import Sequential
from keras.models import load_model
from flask import request
from flask import jsonify
from flask import Flask
import pickle
#from flask_cors import CORS




pickle_in = open("X_train.pickle","rb")
X_train = pickle.load(pickle_in)




from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train  = sc.fit_transform(X_train)
print(sc)

app=Flask(__name__)
#CORS(app)
def get_model():
	global model
	model= load_model('model1_99.keras')
	print("Model Loaded")
print("Loading Model")
get_model()

@app.route("/predict",methods=['POST'])
def predict():
	print("In pytthonnn")
	message = request.get_json(force = True)
	sym1=int(message['sym1'])
	sym2=int(message['sym2'])
	sym3=int(message['sym3'])
	sym4=int(message['sym4'])
	sym5=int(message['sym5'])
	sym6=int(message['sym6'])
	sym7=int(message['sym7'])
	sym8=int(message['sym8'])
	sym9=int(message['sym9'])

	x = np.array([[sym1,sym2,sym3,sym4,sym5,sym6,sym7,sym8,sym9]])
	print(x)
	x = x.reshape(len(x),-1)
	print(x.shape)
	x = sc.transform(x)
	print("Doing preaxas")
	prediction = model.predict(x).astype(int)

	if(prediction>=0.5):
		response ={	"prediction" : 'Malignant' }
		print("malignant")

	else :
		response ={	"prediction" : "Benign" }
		print("bbbbbbbb")
	print(jsonify(response))	
	return jsonify(response)

		

print("Loading Keras Model...")



