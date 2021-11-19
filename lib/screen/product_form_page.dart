import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _desciptionFocus = FocusNode();
  final _urlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _urlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _desciptionFocus.dispose();
    _urlFocus.removeListener(updateImage);
    _urlFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();

    Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
    Navigator.of(context).pop();
  }

  bool isValidmageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool extIsValid = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && extIsValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Produto'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  initialValue: _formData['name']?.toString(),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocus);
                  },
                  onSaved: (name) => _formData['name'] = name ?? '',
                  validator: (_name) {
                    final name = _name ?? '';
                    if (name.trim().isEmpty) {
                      return 'Digite um nome válido';
                    }
                    if (name.length < 3)
                      return 'Digite um nome com pelo menos 3 letras';
                    return null;
                  }),
              TextFormField(
                initialValue: _formData['price']?.toString(),
                decoration: InputDecoration(
                  labelText: 'Preço',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_desciptionFocus);
                },
                focusNode: _priceFocus,
                onSaved: (price) =>
                    _formData['price'] = double.parse(price ?? '0'),
                validator: (_price) {
                  final priceString = _price ?? '';
                  final price = double.tryParse(priceString) ?? -1;
                  if (price <= 0) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _formData['description']?.toString(),
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                  ),
                  focusNode: _desciptionFocus,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_urlFocus);
                  },
                  onSaved: (description) =>
                      _formData['description'] = description ?? '',
                  validator: (_description) {
                    final description = _description ?? '';
                    if (description.trim().isEmpty) {
                      return 'Digite uma descrição válida';
                    }
                    if (description.length < 10)
                      return 'A descrição deve conter pelo menos 10 letras';
                    return null;
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Url da Imagem',
                      ),
                      focusNode: _urlFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) => _submitForm(),
                      onSaved: (imageUrl) =>
                          _formData['imageUrl'] = imageUrl ?? '',
                      validator: (_url) {
                        final url = _url ?? '';
                        if (!isValidmageUrl(url)) return 'Url invalida';
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                    alignment: Alignment.center,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
