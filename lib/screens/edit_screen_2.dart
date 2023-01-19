import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp2/providers/product.dart';
import 'package:shopapp2/providers/product_provider.dart';

class EditScreen2 extends StatefulWidget {
  static const String routeName = 'EditScreen2';

  @override
  _EditScreen2State createState() => _EditScreen2State();
}

class _EditScreen2State extends State<EditScreen2> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _newProduct = Product(
      title: '',
      id: DateTime.now().toString(),
      description: '',
      imageUrl: '',
      price: 0);

  var _existProduct;
  bool _firstRun = true;

  bool _isLoading = false;

  @override
  void initState() {
    _imageFocusNode.addListener(() => _updateImage());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firstRun) {
      var product = ModalRoute.of(context).settings.arguments;
      if (product == null) {
        return;
      } else {
        _existProduct = product;
        _imageController.text = _existProduct.imageUrl;
      }
      _firstRun = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    _formKey.currentState.save();
    bool _isValid = _formKey.currentState.validate();
    if (!_isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    if (_existProduct == null) {
      // if there is no existing product
      // the add to the list
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_newProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Something Wrong happend'),
                  content: Text('Please Try Again later'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  actions: <Widget>[
                    ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextButton(
                        child: Text(
                          'Okay',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                ));
      }
    } else {
      // if the product already is there
      // update it
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProductInfo(_existProduct.id, _existProduct);
      setState(() {
        _isLoading = false;
      });
    }
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  void _updateImage() {
    var imageUrl = _imageController.text;
    if (((!imageUrl.endsWith('.jpg') && (!imageUrl.endsWith('.png'))) ||
        (!imageUrl.startsWith('http') && (!imageUrl.startsWith('https'))))) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Screen'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _submitForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue:
                            _existProduct == null ? '' : _existProduct.title,
                        decoration: InputDecoration(labelText: 'Title'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          if (_existProduct != null) {
                            _existProduct = Product(
                                title: value,
                                id: _existProduct.id,
                                price: _existProduct.price,
                                description: _existProduct.description,
                                imageUrl: _existProduct.imageUrl);
                          } else {
                            _newProduct = Product(
                                title: value,
                                id: _newProduct.id,
                                description: _newProduct.description,
                                price: _newProduct.price,
                                imageUrl: _newProduct.imageUrl);
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please Enter a Title';
                          else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _existProduct == null
                            ? ''
                            : _existProduct.price.toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          if (_existProduct != null) {
                            _existProduct = Product(
                                title: _existProduct.title,
                                id: _existProduct.id,
                                price: double.tryParse(value),
                                description: _existProduct.description,
                                imageUrl: _existProduct.imageUrl);
                          } else {
                            _newProduct = Product(
                                title: _newProduct.title,
                                id: _newProduct.id,
                                description: _newProduct.description,
                                price: double.tryParse(value),
                                imageUrl: _newProduct.imageUrl);
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please Enter a Price';
                          else if (!(num.tryParse(value) is num))
                            return 'Please Enter a number';
                          else if (double.tryParse(value) <= 0)
                            return 'Please Enter a Price';
                          else
                            return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _existProduct == null
                            ? ''
                            : _existProduct.description,
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          if (_existProduct != null) {
                            _existProduct = Product(
                                title: _existProduct.title,
                                id: _existProduct.id,
                                price: _existProduct.price,
                                description: value,
                                imageUrl: _existProduct.imageUrl);
                          } else {
                            _newProduct = Product(
                                title: _newProduct.title,
                                id: _newProduct.id,
                                description: value,
                                price: _newProduct.price,
                                imageUrl: _newProduct.imageUrl);
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Please Enter a Description';
                          else if (value.length < 10)
                            return 'Please Enter at Least 10 Charcters';
                          else
                            return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.black),
                            ),
                            child: _imageController.text.isEmpty
                                ? Center(child: Text('Enter Url'))
                                : Image.network(_imageController.text),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Image'),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                focusNode: _imageFocusNode,
                                controller: _imageController,
                                onFieldSubmitted: (_) {
                                  _submitForm();
                                },
                                onSaved: (value) {
                                  if (_existProduct != null) {
                                    _existProduct = Product(
                                        title: _existProduct.title,
                                        id: _existProduct.id,
                                        price: _existProduct.price,
                                        description: _existProduct.description,
                                        imageUrl: value);
                                  } else {
                                    _newProduct = Product(
                                      title: _newProduct.title,
                                      id: _newProduct.id,
                                      description: _newProduct.description,
                                      price: _newProduct.price,
                                      imageUrl: value,
                                    );
                                  }
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'Please Enter an Image Url';
                                  else if ((!(value.startsWith('http')) &&
                                          !(value.startsWith('https'))) ||
                                      ((!value.endsWith('.jpg')) &&
                                          (!value.endsWith('.png'))))
                                    return 'Please Enter a Valid Image';
                                  else
                                    return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
