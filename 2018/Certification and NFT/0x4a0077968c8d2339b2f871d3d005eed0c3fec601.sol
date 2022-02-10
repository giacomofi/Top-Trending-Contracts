['pragma solidity ^0.4.18;\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', '    // these functions aren&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function name() public view returns (string) {}\n', '    function symbol() public view returns (string) {}\n', '    function decimals() public view returns (uint8) {}\n', '    function totalSupply() public view returns (uint256) {}\n', '    function balanceOf(address _owner) public view returns (uint256) { _owner; }\n', '    function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', '    // this function isn&#39;t abstract since the compiler emits automatically generated getter functions as external\n', '    function owner() public view returns (address) {}\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '    function changeOwner(address _newOwner) public;\n', '}\n', '\n', '\n', '\n', '/*\n', '    Bancor Quick Converter interface\n', '*/\n', 'contract IBancorQuickConverter {\n', '    function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);\n', '    function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);\n', '}\n', '\n', '\n', '/*\n', '    Bancor Gas Price Limit interface\n', '*/\n', 'contract IBancorGasPriceLimit {\n', '    function gasPrice() public view returns (uint256) {}\n', '}\n', '\n', '\n', '/*\n', '    Bancor Formula interface\n', '*/\n', 'contract IBancorFormula {\n', '    function calculatePurchaseReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _depositAmount) public view returns (uint256);\n', '    function calculateSaleReturn(uint256 _supply, uint256 _connectorBalance, uint32 _connectorWeight, uint256 _sellAmount) public view returns (uint256);\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Bancor Converter Extensions interface\n', '*/\n', 'contract IBancorConverterExtensions {\n', '    function formula() public view returns (IBancorFormula) {}\n', '    function gasPriceLimit() public view returns (IBancorGasPriceLimit) {}\n', '    function quickConverter() public view returns (IBancorQuickConverter) {}\n', '}\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() public {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still needs to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = address(0);\n', '    }\n', '\n', '    function changeOwner(address _newOwner) public ownerOnly {\n', '      owner = _newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '/*\n', '    Utilities & Common Modifiers\n', '*/\n', 'contract Utils {\n', '    /**\n', '        constructor\n', '    */\n', '    function Utils() public {\n', '    }\n', '\n', '    // verifies that an amount is greater than zero\n', '    modifier greaterThanZero(uint256 _amount) {\n', '        require(_amount > 0);\n', '        _;\n', '    }\n', '\n', '    // validates an address - currently only checks that it isn&#39;t null\n', '    modifier validAddress(address _address) {\n', '        require(_address != address(0));\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    // Overflow protected math functions\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '}\n', '\n', '\n', '\n', '\n', '\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '\n', '/*\n', '    We consider every contract to be a &#39;token holder&#39; since it&#39;s currently not possible\n', '    for a contract to deny receiving tokens.\n', '\n', '    The TokenHolder&#39;s contract sole purpose is to provide a safety mechanism that allows\n', '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned, Utils {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function TokenHolder() public {\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '\n', '\n', '/**\n', '    @dev the BancorConverterExtensions contract is an owned contract that serves as a single point of access\n', '    to the BancorFormula, BancorGasPriceLimit and BancorQuickConverter contracts from all BancorConverter contract instances.\n', '    it allows upgrading these contracts without the need to update each and every\n', '    BancorConverter contract instance individually.\n', '*/\n', 'contract BancorConverterExtensions is IBancorConverterExtensions, TokenHolder {\n', '    IBancorFormula public formula;  // bancor calculation formula contract\n', '    IBancorGasPriceLimit public gasPriceLimit; // bancor universal gas price limit contract\n', '    IBancorQuickConverter public quickConverter; // bancor quick converter contract\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _formula         address of a bancor formula contract\n', '        @param _gasPriceLimit   address of a bancor gas price limit contract\n', '        @param _quickConverter  address of a bancor quick converter contract\n', '    */\n', '    function BancorConverterExtensions(IBancorFormula _formula, IBancorGasPriceLimit _gasPriceLimit, IBancorQuickConverter _quickConverter)\n', '        public\n', '        validAddress(_formula)\n', '        validAddress(_gasPriceLimit)\n', '        validAddress(_quickConverter)\n', '    {\n', '        formula = _formula;\n', '        gasPriceLimit = _gasPriceLimit;\n', '        quickConverter = _quickConverter;\n', '    }\n', '\n', '    /*\n', '        @dev allows the owner to update the formula contract address\n', '\n', '        @param _formula    address of a bancor formula contract\n', '    */\n', '    function setFormula(IBancorFormula _formula)\n', '        public\n', '        ownerOnly\n', '        validAddress(_formula)\n', '        notThis(_formula)\n', '    {\n', '        formula = _formula;\n', '    }\n', '\n', '    /*\n', '        @dev allows the owner to update the gas price limit contract address\n', '\n', '        @param _gasPriceLimit   address of a bancor gas price limit contract\n', '    */\n', '    function setGasPriceLimit(IBancorGasPriceLimit _gasPriceLimit)\n', '        public\n', '        ownerOnly\n', '        validAddress(_gasPriceLimit)\n', '        notThis(_gasPriceLimit)\n', '    {\n', '        gasPriceLimit = _gasPriceLimit;\n', '    }\n', '\n', '    /*\n', '        @dev allows the owner to update the quick converter contract address\n', '\n', '        @param _quickConverter  address of a bancor quick converter contract\n', '    */\n', '    function setQuickConverter(IBancorQuickConverter _quickConverter)\n', '        public\n', '        ownerOnly\n', '        validAddress(_quickConverter)\n', '        notThis(_quickConverter)\n', '    {\n', '        quickConverter = _quickConverter;\n', '    }\n', '}']