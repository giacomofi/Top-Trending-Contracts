['pragma solidity ^0.4.11;\n', '\n', '/*\n', '    Overflow protected math functions\n', '*/\n', 'contract SafeMath {\n', '    /**\n', '        constructor\n', '    */\n', '    function SafeMath() {\n', '    }\n', '\n', '    /**\n', '        @dev returns the sum of _x and _y, asserts if the calculation overflows\n', '\n', '        @param _x   value 1\n', '        @param _y   value 2\n', '\n', '        @return sum\n', '    */\n', '    function safeAdd(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x + _y;\n', '        assert(z >= _x);\n', '        return z;\n', '    }\n', '\n', '    /**\n', '        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number\n', '\n', '        @param _x   minuend\n', '        @param _y   subtrahend\n', '\n', '        @return difference\n', '    */\n', '    function safeSub(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        assert(_x >= _y);\n', '        return _x - _y;\n', '    }\n', '\n', '    /**\n', '        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows\n', '\n', '        @param _x   factor 1\n', '        @param _y   factor 2\n', '\n', '        @return product\n', '    */\n', '    function safeMul(uint256 _x, uint256 _y) internal returns (uint256) {\n', '        uint256 z = _x * _y;\n', '        assert(_x == 0 || z / _x == _y);\n', '        return z;\n', '    }\n', '} \n', '\n', '/*\n', '    Owned contract interface\n', '*/\n', 'contract IOwned {\n', "    // this function isn't abstract since the compiler emits automatically generated getter functions as external\n", '    function owner() public constant returns (address owner) { owner; }\n', '\n', '    function transferOwnership(address _newOwner) public;\n', '    function acceptOwnership() public;\n', '}\n', '\n', '/*\n', '    Provides support and utilities for contract ownership\n', '*/\n', 'contract Owned is IOwned {\n', '    address public owner;\n', '    address public newOwner;\n', '\n', '    event OwnerUpdate(address _prevOwner, address _newOwner);\n', '\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function Owned() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    // allows execution by the owner only\n', '    modifier ownerOnly {\n', '        assert(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev allows transferring the contract ownership\n', '        the new owner still need to accept the transfer\n', '        can only be called by the contract owner\n', '\n', '        @param _newOwner    new contract owner\n', '    */\n', '    function transferOwnership(address _newOwner) public ownerOnly {\n', '        require(_newOwner != owner);\n', '        newOwner = _newOwner;\n', '    }\n', '\n', '    /**\n', '        @dev used by a new owner to accept an ownership transfer\n', '    */\n', '    function acceptOwnership() public {\n', '        require(msg.sender == newOwner);\n', '        OwnerUpdate(owner, newOwner);\n', '        owner = newOwner;\n', '        newOwner = 0x0;\n', '    }\n', '}\n', '\n', '/*\n', '    ERC20 Standard Token interface\n', '*/\n', 'contract IERC20Token {\n', "    // these functions aren't abstract since the compiler emits automatically generated getter functions as external\n", '    function name() public constant returns (string name) { name; }\n', '    function symbol() public constant returns (string symbol) { symbol; }\n', '    function decimals() public constant returns (uint8 decimals) { decimals; }\n', '    function totalSupply() public constant returns (uint256 totalSupply) { totalSupply; }\n', '    function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }\n', '    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '}\n', '\n', '/*\n', '    Token Holder interface\n', '*/\n', 'contract ITokenHolder is IOwned {\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;\n', '}\n', '\n', '/*\n', "    We consider every contract to be a 'token holder' since it's currently not possible\n", '    for a contract to deny receiving tokens.\n', '\n', "    The TokenHolder's contract sole purpose is to provide a safety mechanism that allows\n", '    the owner to send tokens that were sent to the contract by mistake back to their sender.\n', '*/\n', 'contract TokenHolder is ITokenHolder, Owned {\n', '    /**\n', '        @dev constructor\n', '    */\n', '    function TokenHolder() {\n', '    }\n', '\n', "    // validates an address - currently only checks that it isn't null\n", '    modifier validAddress(address _address) {\n', '        require(_address != 0x0);\n', '        _;\n', '    }\n', '\n', '    // verifies that the address is different than this contract address\n', '    modifier notThis(address _address) {\n', '        require(_address != address(this));\n', '        _;\n', '    }\n', '\n', '    /**\n', '        @dev withdraws tokens held by the contract and sends them to an account\n', '        can only be called by the owner\n', '\n', '        @param _token   ERC20 token contract address\n', '        @param _to      account to receive the new amount\n', '        @param _amount  amount to withdraw\n', '    */\n', '    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount)\n', '        public\n', '        ownerOnly\n', '        validAddress(_token)\n', '        validAddress(_to)\n', '        notThis(_to)\n', '    {\n', '        assert(_token.transfer(_to, _amount));\n', '    }\n', '}\n', '\n', '/*\n', '    Smart Token interface\n', '*/\n', 'contract ISmartToken is ITokenHolder, IERC20Token {\n', '    function disableTransfers(bool _disable) public;\n', '    function issue(address _to, uint256 _amount) public;\n', '    function destroy(address _from, uint256 _amount) public;\n', '}\n', '\n', '/*\n', '    BancorPriceFloor v0.1\n', '\n', '    The bancor price floor contract is a simple contract that allows selling smart tokens for a constant ETH price\n', '\n', "    'Owned' is specified here for readability reasons\n", '*/\n', 'contract BancorPriceFloor is Owned, TokenHolder, SafeMath {\n', '    uint256 public constant TOKEN_PRICE_N = 1;      // crowdsale price in wei (numerator)\n', '    uint256 public constant TOKEN_PRICE_D = 100;    // crowdsale price in wei (denominator)\n', '\n', "    string public version = '0.1';\n", '    ISmartToken public token; // smart token the contract allows selling\n', '\n', '    /**\n', '        @dev constructor\n', '\n', '        @param _token   smart token the contract allows selling\n', '    */\n', '    function BancorPriceFloor(ISmartToken _token)\n', '        validAddress(_token)\n', '    {\n', '        token = _token;\n', '    }\n', '\n', '    /**\n', '        @dev sells the smart token for ETH\n', '        note that the function will sell the full allowance amount\n', '\n', '        @return ETH sent in return\n', '    */\n', '    function sell() public returns (uint256 amount) {\n', '        uint256 allowance = token.allowance(msg.sender, this); // get the full allowance amount\n', '        assert(token.transferFrom(msg.sender, this, allowance)); // transfer all tokens from the sender to the contract\n', '        uint256 etherValue = safeMul(allowance, TOKEN_PRICE_N) / TOKEN_PRICE_D; // calculate ETH value of the tokens\n', '        msg.sender.transfer(etherValue); // send the ETH amount to the seller\n', '        return etherValue;\n', '    }\n', '\n', '    /**\n', '        @dev withdraws ETH from the contract\n', '\n', '        @param _amount  amount of ETH to withdraw\n', '    */\n', '    function withdraw(uint256 _amount) public ownerOnly {\n', '        assert(msg.sender.send(_amount)); // send the amount\n', '    }\n', '\n', '    /**\n', '        @dev deposits ETH in the contract\n', '    */\n', '    function() public payable {\n', '    }\n', '}']