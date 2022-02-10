['pragma solidity ^0.4.23;\n', '\n', '\n', '/**\n', ' * @title Signature verifier\n', ' * @dev To verify C level actions\n', ' */\n', 'contract SignatureVerifier {\n', '\n', '    function splitSignature(bytes sig)\n', '    internal\n', '    pure\n', '    returns (uint8, bytes32, bytes32)\n', '    {\n', '        require(sig.length == 65);\n', '\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '\n', '        assembly {\n', '        // first 32 bytes, after the length prefix\n', '            r := mload(add(sig, 32))\n', '        // second 32 bytes\n', '            s := mload(add(sig, 64))\n', '        // final byte (first byte of the next 32 bytes)\n', '            v := byte(0, mload(add(sig, 96)))\n', '        }\n', '        return (v, r, s);\n', '    }\n', '\n', '    // Returns the address that signed a given string message\n', '    function verifyString(\n', '        string message,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s)\n', '    internal pure\n', '    returns (address signer) {\n', '\n', '        // The message header; we will fill in the length next\n', '        string memory header = "\\x19Ethereum Signed Message:\\n000000";\n', '        uint256 lengthOffset;\n', '        uint256 length;\n', '\n', '        assembly {\n', '        // The first word of a string is its length\n', '            length := mload(message)\n', '        // The beginning of the base-10 message length in the prefix\n', '            lengthOffset := add(header, 57)\n', '        }\n', '\n', '        // Maximum length we support\n', '        require(length <= 999999);\n', "        // The length of the message's length in base-10\n", '        uint256 lengthLength = 0;\n', '        // The divisor to get the next left-most message length digit\n', '        uint256 divisor = 100000;\n', '        // Move one digit of the message length to the right at a time\n', '\n', '        while (divisor != 0) {\n', '            // The place value at the divisor\n', '            uint256 digit = length / divisor;\n', '            if (digit == 0) {\n', '                // Skip leading zeros\n', '                if (lengthLength == 0) {\n', '                    divisor /= 10;\n', '                    continue;\n', '                }\n', '            }\n', '            // Found a non-zero digit or non-leading zero digit\n', '            lengthLength++;\n', "            // Remove this digit from the message length's current value\n", '            length -= digit * divisor;\n', '            // Shift our base-10 divisor over\n', '            divisor /= 10;\n', '\n', '            // Convert the digit to its ASCII representation (man ascii)\n', '            digit += 0x30;\n', '            // Move to the next character and write the digit\n', '            lengthOffset++;\n', '            assembly {\n', '                mstore8(lengthOffset, digit)\n', '            }\n', '        }\n', '        // The null string requires exactly 1 zero (unskip 1 leading 0)\n', '        if (lengthLength == 0) {\n', '            lengthLength = 1 + 0x19 + 1;\n', '        } else {\n', '            lengthLength += 1 + 0x19;\n', '        }\n', '        // Truncate the tailing zeros from the header\n', '        assembly {\n', '            mstore(header, lengthLength)\n', '        }\n', '        // Perform the elliptic curve recover operation\n', '        bytes32 check = keccak256(abi.encodePacked(header, message));\n', '        return ecrecover(check, v, r, s);\n', '    }\n', '}\n', '\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '\n', '    /**\n', '     * @dev Multiplies two numbers, throws on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', "        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two numbers, truncating the quotient.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        // uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return a / b;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two numbers, throws on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '/**\n', ' * @title A DEKLA token access control\n', ' * @author DEKLA (https://www.dekla.io)\n', ' * @dev The Dekla token has 3 C level address to manage.\n', ' * They can execute special actions but it need to be approved by another C level address.\n', ' */\n', 'contract AccessControl is SignatureVerifier {\n', '    using SafeMath for uint256;\n', '\n', '    // C level address that can execute special actions.\n', '    address public ceoAddress;\n', '    address public cfoAddress;\n', '    address public cooAddress;\n', '    address public systemAddress;\n', '    uint256 public CLevelTxCount_ = 0;\n', '\n', '    // @dev store nonces\n', '    mapping(address => uint256) nonces;\n', '\n', '    // @dev C level transaction must be approved with another C level address\n', '    modifier onlyCLevel() {\n', '        require(\n', '            msg.sender == cooAddress ||\n', '            msg.sender == ceoAddress ||\n', '            msg.sender == cfoAddress\n', '        );\n', '        _;\n', '    }\n', '\n', '    modifier onlySystem() {\n', '        require(msg.sender == systemAddress);\n', '        _;\n', '    }\n', '\n', '    function recover(bytes32 hash, bytes sig) public pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        //Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '        // Divide the signature in r, s and v variables\n', '        (v, r, s) = splitSignature(sig);\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            bytes memory prefix = "\\x19Ethereum Signed Message:\\n32";\n', '            bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));\n', '            return ecrecover(prefixedHash, v, r, s);\n', '        }\n', '    }\n', '\n', '    function signedCLevel(\n', '        bytes32 _message,\n', '        bytes _sig\n', '    )\n', '    internal\n', '    view\n', '    onlyCLevel\n', '    returns (bool)\n', '    {\n', '        address signer = recover(_message, _sig);\n', '\n', '        require(signer != msg.sender);\n', '        return (\n', '        signer == cooAddress ||\n', '        signer == ceoAddress ||\n', '        signer == cfoAddress\n', '        );\n', '    }\n', '\n', '    event addressLogger(address signer);\n', '\n', '    /**\n', '     * @notice Hash (keccak256) of the payload used by setCEO\n', '     * @param _newCEO address The address of the new CEO\n', '     * @param _nonce uint256 setCEO transaction number.\n', '     */\n', '    function getCEOHashing(address _newCEO, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0F3E), _newCEO, _nonce));\n', '    }\n', '\n', '    // @dev Assigns a new address to act as the CEO. The C level transaction, must verify.\n', '    // @param _newCEO The address of the new CEO\n', '    function setCEO(\n', '        address _newCEO,\n', '        bytes _sig\n', '    ) external onlyCLevel {\n', '        require(\n', '            _newCEO != address(0) &&\n', '            _newCEO != cfoAddress &&\n', '            _newCEO != cooAddress\n', '        );\n', '\n', '        bytes32 hashedTx = getCEOHashing(_newCEO, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        nonces[msg.sender]++;\n', '\n', '        ceoAddress = _newCEO;\n', '        CLevelTxCount_++;\n', '    }\n', '\n', '    /**\n', '     * @notice Hash (keccak256) of the payload used by setCFO\n', '     * @param _newCFO address The address of the new CFO\n', '     * @param _nonce uint256 setCEO transaction number.\n', '     */\n', '    function getCFOHashing(address _newCFO, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0F01), _newCFO, _nonce));\n', '    }\n', '\n', '    // @dev Assigns a new address to act as the CFO. The C level transaction, must verify.\n', '    // @param _newCFO The address of the new CFO\n', '    function setCFO(\n', '        address _newCFO,\n', '        bytes _sig\n', '    ) external onlyCLevel {\n', '        require(\n', '            _newCFO != address(0) &&\n', '            _newCFO != ceoAddress &&\n', '            _newCFO != cooAddress\n', '        );\n', '\n', '        bytes32 hashedTx = getCFOHashing(_newCFO, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        nonces[msg.sender]++;\n', '\n', '        cfoAddress = _newCFO;\n', '        CLevelTxCount_++;\n', '    }\n', '\n', '    /**\n', '     * @notice Hash (keccak256) of the payload used by setCOO\n', '     * @param _newCOO address The address of the new COO\n', '     * @param _nonce uint256 setCEO transaction number.\n', '     */\n', '    function getCOOHashing(address _newCOO, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0F02), _newCOO, _nonce));\n', '    }\n', '\n', '    // @dev Assigns a new address to act as the COO. The C level transaction, must verify.\n', '    // @param _newCOO The address of the new COO, _sig signature used to verify COO address\n', '    function setCOO(\n', '        address _newCOO,\n', '        bytes _sig\n', '    ) external onlyCLevel {\n', '        require(\n', '            _newCOO != address(0) &&\n', '            _newCOO != ceoAddress &&\n', '            _newCOO != cfoAddress\n', '        );\n', '\n', '        bytes32 hashedTx = getCOOHashing(_newCOO, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        nonces[msg.sender]++;\n', '\n', '        cooAddress = _newCOO;\n', '        CLevelTxCount_++;\n', '    }\n', '\n', '    function getNonce() external view returns (uint256) {\n', '        return nonces[msg.sender];\n', '    }\n', '}\n', '\n', '\n', 'interface ERC20 {\n', '    function transfer(address _to, uint _value) external returns (bool success);\n', '\n', '    function balanceOf(address who) external view returns (uint256);\n', '}\n', '\n', 'contract SaleToken is AccessControl {\n', '    using SafeMath for uint256;\n', '\n', '    // @dev This define events\n', '    event BuyDeklaSuccessful(uint256 dekla, address buyer);\n', '    event UpdateDeklaPriceSuccessful(uint256 price, address sender);\n', '    event WithdrawEthSuccessful(address sender, uint256 amount);\n', '    event WithdrawDeklaSuccessful(address sender, uint256 amount);\n', '    event UpdateMinimumPurchaseAmountSuccessful(address sender, uint256 percent);\n', '\n', '    // @dev This is price of 1 DKL (Dekla Token)\n', '    // Current: 1 DKL = 0.005$\n', '    uint256 public deklaTokenPrice = 22590000000000;\n', '\n', '    uint256 public decimals = 18;\n', '\n', '    // @dev minimum purchase amount\n', '    uint256 public minimumPurchaseAmount;\n', '\n', '    // @dev store nonces\n', '    mapping(address => uint256) nonces;\n', '\n', '    address public systemAddress;\n', '\n', '    // ERC20 basic token contract being held\n', '    ERC20 public token;\n', '\n', '    constructor(\n', '        address _ceoAddress,\n', '        address _cfoAddress,\n', '        address _cooAddress,\n', '        address _systemAddress\n', '    ) public {\n', '        // initial C level address\n', '        ceoAddress = _ceoAddress;\n', '        cfoAddress = _cfoAddress;\n', '        cooAddress = _cooAddress;\n', '        systemAddress = _systemAddress;\n', '        minimumPurchaseAmount = 50 * (10 ** decimals);\n', '    }\n', '\n', '    //check that the token is set\n', '    modifier validToken() {\n', '        require(token != address(0));\n', '        _;\n', '    }\n', '\n', '    modifier onlySystem() {\n', '        require(msg.sender == systemAddress);\n', '        _;\n', '    }\n', '\n', '    function recover(bytes32 hash, bytes sig) public pure returns (address) {\n', '        bytes32 r;\n', '        bytes32 s;\n', '        uint8 v;\n', '        //Check the signature length\n', '        if (sig.length != 65) {\n', '            return (address(0));\n', '        }\n', '        // Divide the signature in r, s and v variables\n', '        (v, r, s) = splitSignature(sig);\n', '        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions\n', '        if (v < 27) {\n', '            v += 27;\n', '        }\n', '        // If the version is correct return the signer address\n', '        if (v != 27 && v != 28) {\n', '            return (address(0));\n', '        } else {\n', '            bytes memory prefix = "\\x19Ethereum Signed Message:\\n32";\n', '            bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));\n', '            return ecrecover(prefixedHash, v, r, s);\n', '        }\n', '    }\n', '\n', '    function getNonces(address _sender) public view returns (uint256) {\n', '        return nonces[_sender];\n', '    }\n', '\n', '    function setDeklaPrice(uint256 _price) external onlySystem {\n', '        deklaTokenPrice = _price;\n', '        emit UpdateDeklaPriceSuccessful(_price, msg.sender);\n', '    }\n', '\n', '    function setMinimumPurchaseAmount(uint256 _price) external onlySystem {\n', '        minimumPurchaseAmount = _price;\n', '        emit UpdateMinimumPurchaseAmountSuccessful(msg.sender, _price);\n', '    }\n', '\n', '    function getTokenAddressHashing(address _token, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0E30), _token, _nonce));\n', '    }\n', '\n', '    function setTokenAddress(address _token, bytes _sig) external onlyCLevel {\n', '        bytes32 hashedTx = getTokenAddressHashing(_token, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        token = ERC20(_token);\n', '    }\n', '\n', '    // @dev calculate Dekla Token received with ETH\n', '    function calculateDekla(uint256 _value) external view returns (uint256) {\n', '        require(_value >= deklaTokenPrice);\n', '        return _value.div(deklaTokenPrice);\n', '    }\n', '\n', '    // @dev buy dekla token, with eth balance\n', '    // @param value is eth balance\n', '    function() external payable validToken {\n', '        // calculate how much Dekla Token buyer will have\n', '        uint256 amount = msg.value.div(deklaTokenPrice) * (10 ** decimals);\n', '\n', '        // require minimum purchase amount\n', '        require(amount >= minimumPurchaseAmount);\n', '\n', '        // check total Dekla Token of owner\n', '        require(token.balanceOf(this) >= amount);\n', '\n', '        token.transfer(msg.sender, amount);\n', '        emit BuyDeklaSuccessful(amount, msg.sender);\n', '    }\n', '\n', '    // @dev - get message hashing of withdraw eth\n', '    // @param - _address of withdraw wallet\n', '    // @param - _nonce\n', '    function withdrawEthHashing(address _address, uint256 _amount, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0E32), _address, _amount, _nonce));\n', '    }\n', '\n', '    // @dev withdraw ETH balance from owner to wallet input\n', '    // @param _withdrawWallet is wallet address of receiver ETH\n', '    // @param _sig bytes\n', '    function withdrawEth(address _withdrawWallet, uint256 _amount, bytes _sig) external onlyCLevel {\n', '        bytes32 hashedTx = withdrawEthHashing(_withdrawWallet, _amount, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        nonces[msg.sender]++;\n', '\n', '        uint256 balance = address(this).balance;\n', '\n', '        // balance should be greater than 0\n', '        require(balance > 0);\n', '\n', '        // balance should be greater than amount\n', '        require(balance >= _amount);\n', '\n', '        _withdrawWallet.transfer(_amount);\n', '        emit WithdrawEthSuccessful(_withdrawWallet, _amount);\n', '    }\n', '\n', '    // @dev - get message hashing of withdraw dkl\n', '    // @param - _address of withdraw wallet\n', '    // @param - _nonce\n', '    function withdrawDeklaHashing(address _address, uint256 _amount, uint256 _nonce) public pure returns (bytes32) {\n', '        return keccak256(abi.encodePacked(bytes4(0x486A0E33), _address, _amount, _nonce));\n', '    }\n', '\n', '    // @dev withdraw DKL balance from owner to wallet input\n', '    // @param _withdrawWallet is wallet address of receiver DKL\n', '    // @param _sig bytes\n', '    function withdrawDekla(address _withdrawWallet, uint256 _amount, bytes _sig) external validToken onlyCLevel {\n', '        bytes32 hashedTx = withdrawDeklaHashing(_withdrawWallet, _amount, nonces[msg.sender]);\n', '        require(signedCLevel(hashedTx, _sig));\n', '        nonces[msg.sender]++;\n', '\n', '        uint256 balance = token.balanceOf(this);\n', '\n', '        // balance should be greater than 0\n', '        require(balance > 0);\n', '\n', '        // balance should be greater than amount\n', '        require(balance >= _amount);\n', '\n', '        // transfer dekla to receiver\n', '        token.transfer(_withdrawWallet, _amount);\n', '        emit WithdrawDeklaSuccessful(_withdrawWallet, _amount);\n', '    }\n', '}']