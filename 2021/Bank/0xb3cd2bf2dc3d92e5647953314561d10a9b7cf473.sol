['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-18\n', '*/\n', '\n', 'pragma solidity ^0.7.5;\n', '\n', 'interface erc20 {\n', '    function balanceOf(address _owner) external view returns (uint balance);\n', '    function transfer(address _to, uint _value) external returns (bool success);\n', '    function transferFrom(address _from, address _to, uint _value) external returns (bool success);\n', '    function allowance(address _owner, address _spender) external view returns (uint remaining);\n', '    function decimals() external view returns(uint digits);    \n', '}\n', '\n', 'interface erc20Validation {\n', '    function balanceOf(address _address, address _tokenAddress) external view returns (uint balance);    \n', '}\n', '\n', 'contract bazarswap\n', '{\t\n', '\n', 'address public _owner;\n', '\n', 'uint public fee;\n', 'uint public feeDecimals;\n', '\n', 'address public payoutAddress;\n', '\n', 'modifier onlyOwner(){\n', '    require(msg.sender == _owner);\n', '     _;\n', '}\n', '\t\n', 'constructor() {\n', '\t_owner = msg.sender;\n', '\tfeeDecimals = 1000000;\n', '}\n', '\n', 'event AddTokenEvent(address indexed _tokenAddress);\n', 'event SetForSaleEvent(address indexed _seller, address indexed _tokenAddress, uint _balance, uint _weiPriceUnitToken, bool update);\n', 'event RemovedFromSaleEvent(address indexed _seller, address indexed _tokenAddress);\n', 'event SoldEvent(address indexed _seller, address indexed _buyer, address indexed _tokenAddress, uint256 _balance, uint _weiPriceUnitToken, uint _totalPrice, uint _fee);\n', '\n', 'mapping (address => address) public SecondaryValidation;\n', 'mapping (address => mapping (address => uint)) public weiPriceUnitTokenList;\n', '\n', 'function SetForSale(address tokenAddress, uint weiPriceUnitToken) public\n', '{\t\n', "\tif (weiPriceUnitToken == 0) revert('price cannot be zero');\n", '\t\t\n', '\terc20 token = erc20(tokenAddress);\n', '\tuint balance = token.balanceOf(msg.sender);\n', '\t\n', '\tif (SecondaryValidation[tokenAddress] != 0x0000000000000000000000000000000000000000)\n', '\t{\n', '\t\terc20Validation vc = erc20Validation(SecondaryValidation[tokenAddress]);\n', '\t\tbalance = vc.balanceOf(msg.sender, tokenAddress);\n', '\t}\n', '\t\n', "\tif (balance == 0) revert('balance cannot be zero');\n", "\tif (token.allowance(msg.sender, address(this)) < balance) revert('approve not granted');\n", '\t\n', '\tif (weiPriceUnitTokenList[msg.sender][tokenAddress] == 0)\n', '\t{\n', '\t\temit AddTokenEvent(tokenAddress);\n', '\t\temit SetForSaleEvent(msg.sender, tokenAddress, balance, weiPriceUnitToken, false);\n', '\t}\n', '\telse\n', '\t{\n', '\t\temit SetForSaleEvent(msg.sender, tokenAddress, balance, weiPriceUnitToken, true);\n', '\t}\n', '\t\n', '\tweiPriceUnitTokenList[msg.sender][tokenAddress] = weiPriceUnitToken;\n', '}\n', '\n', 'function Buy(address seller, address tokenAddress) public payable\n', '{\t\n', "\tif (seller == msg.sender) revert('buyer and seller cannot be the same');\n", '\t\n', '\terc20 token = erc20(tokenAddress);\n', '\tuint allowance = getAvailableBalanceForSale(seller, tokenAddress);\n', '\t\n', '\tuint sellerPrice = weiPriceUnitTokenList[seller][tokenAddress] * allowance / 10**token.decimals();\n', '\tuint buyFee = fee * sellerPrice / feeDecimals;\n', '\t\n', "\tif ((msg.value != sellerPrice + buyFee) || msg.value == 0) revert('Price sent not correct');\n", '\t\n', '\ttoken.transferFrom(seller, msg.sender, allowance);\n', '\t\n', "\tif(!payable(seller).send(sellerPrice)) revert('Error while sending payment to seller');\t\n", '\t\n', '\temit SoldEvent(seller, msg.sender, tokenAddress, allowance, weiPriceUnitTokenList[seller][tokenAddress], (sellerPrice + buyFee), buyFee);\n', '\t\n', '\tweiPriceUnitTokenList[seller][tokenAddress] = 0;\n', '}\n', '\n', 'function RemoveFromSale(address tokenAddress, bool checkAllowance) public\n', '{\n', "\tif (getTokenAllowance(msg.sender, tokenAddress) > 0 && checkAllowance) revert('Approve Needs to be Removed First');\n", '\tif (weiPriceUnitTokenList[msg.sender][tokenAddress] != 0)\n', '\t{\t\t\n', '\t\tweiPriceUnitTokenList[msg.sender][tokenAddress] = 0;\n', '\t\temit RemovedFromSaleEvent(msg.sender, tokenAddress);\n', '\t}\n', '\telse\n', '\t{\n', "\t\trevert('Token not set for sale');\n", '\t}\n', '}\n', '\n', 'function getWeiPriceUnitTokenList(address seller, address tokenAddress) public view returns(uint) \n', '{\n', '\treturn weiPriceUnitTokenList[seller][tokenAddress];\n', '}\n', '\n', 'function getFinalPrice(address seller, address tokenAddress) public view returns(uint) \n', '{\n', '\terc20 token = erc20(tokenAddress);\n', '\tuint allowance = getAvailableBalanceForSale(seller, tokenAddress);\n', '\tuint sellerPrice = weiPriceUnitTokenList[seller][tokenAddress] * allowance / 10**token.decimals();\n', '\tuint buyFee = fee * sellerPrice / feeDecimals;\n', '\treturn sellerPrice + buyFee;\n', '}\n', '\n', 'function getFinalPriceWithoutFee(address seller, address tokenAddress) public view returns(uint) \n', '{\n', '\terc20 token = erc20(tokenAddress);\n', '\tuint allowance = getAvailableBalanceForSale(seller, tokenAddress);\n', '\tuint sellerPrice = weiPriceUnitTokenList[seller][tokenAddress] * allowance / 10**token.decimals();\n', '\treturn sellerPrice;\n', '}\n', '\n', 'function getTokenAllowance(address seller, address tokenAddress) public view returns(uint)\n', '{\n', '\terc20 token = erc20(tokenAddress);\n', '\treturn token.allowance(seller, address(this));\n', '}\n', '\n', 'function getAvailableBalanceForSale(address seller, address tokenAddress) public view returns(uint)\n', '{\n', '\tuint allowance = erc20(tokenAddress).allowance(seller, address(this));\n', '\tif (SecondaryValidation[tokenAddress] == 0x0000000000000000000000000000000000000000)\n', '\t{\n', '\t    uint balance = erc20(tokenAddress).balanceOf(seller);\n', '\t\tif (balance > allowance)\n', '\t\t\treturn allowance;\n', '\t\telse\n', '\t\t\treturn balance;\t\t\n', '\t}\n', '\telse\n', '\t{\t\n', '\t\tuint balance = erc20Validation(SecondaryValidation[tokenAddress]).balanceOf(seller, tokenAddress);\n', '\t\tif (balance > allowance)\n', '\t\t\treturn allowance;\n', '\t\telse\n', '\t\t\treturn balance;\n', '\t}\n', '}\n', '\n', 'function setForSaleBalance(address seller, address tokenAddress) public view returns(uint)\n', '{\n', '\tif (SecondaryValidation[tokenAddress] == 0x0000000000000000000000000000000000000000)\n', '\t{\n', '\t    return erc20(tokenAddress).balanceOf(seller);\t\t\t\n', '\t}\n', '\telse\n', '\t{\t\n', '\t\treturn erc20Validation(SecondaryValidation[tokenAddress]).balanceOf(seller, tokenAddress);\t\t\n', '\t}\n', '}\n', '\n', 'function setSecondaryValidation(address tokenAddress, address validationContractAddress) public onlyOwner\n', '{\n', '\tSecondaryValidation[tokenAddress] = validationContractAddress;\n', '}\n', '\n', 'function setFee(uint _fee) public onlyOwner\n', '{\n', '\tfee = _fee;\n', '}\n', '\n', 'function setPayoutAddress(address _address) public onlyOwner\n', '{\n', '\tpayoutAddress = _address;\n', '}\n', '\n', 'function setFeeDecimals(uint _feeDecimals) public onlyOwner\n', '{\n', '\tfeeDecimals = _feeDecimals;\n', '}\n', '\n', 'function approvePayout() public\n', '{\n', "\tif(!payable(payoutAddress).send(address(this).balance)) revert('Error while sending payment');\t\n", '}\n', '}']