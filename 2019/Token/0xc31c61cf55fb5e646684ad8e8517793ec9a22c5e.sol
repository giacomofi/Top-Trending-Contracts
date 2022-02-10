['pragma solidity >=0.5.7 <0.6.0;\n', '\n', '/*\n', '*  xEuro.sol\n', '*  xEUR tokens smart contract\n', '*  implements [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)\n', '*  ver. 1.0.0\n', '*  2019-04-15\n', '*  https://xeuro.online\n', '*  https://etherscan.io/address/0xC31C61cf55fB5E646684AD8E8517793ec9A22c5e\n', '*  deployed on block: 7571826\n', '*  solc version :  0.5.7+commit.6da8b019\n', '**/\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Unsigned math operations with safety checks that revert on error\n', ' */\n', 'library SafeMath {\n', '    /**\n', '     * @dev Multiplies two unsigned integers, reverts on overflow.\n', '     */\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.\n', '     */\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Adds two unsigned integers, reverts on overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a);\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),\n', '     * reverts when dividing by zero.\n', '     */\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b != 0);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/* "Interfaces" */\n', '\n', '// see: https://github.com/ethereum/EIPs/issues/677\n', 'contract tokenRecipient {\n', '    function tokenFallback(address _from, uint256 _value, bytes memory _extraData) public returns (bool);\n', '}\n', '\n', 'contract xEuro {\n', '\n', '    // see: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol\n', '    using SafeMath for uint256;\n', '\n', '    /* --- ERC-20 variables ----- */\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name\n', '    // function name() constant returns (string name)\n', '    string public name = "xEuro";\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol\n', '    // function symbol() constant returns (string symbol)\n', '    string public symbol = "xEUR";\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals\n', '    // function decimals() constant returns (uint8 decimals)\n', '    uint8 public decimals = 0; // 1 token = €1, no smaller unit\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply\n', '    // function totalSupply() constant returns (uint256 totalSupply)\n', '    // we start with zero\n', '    uint256 public totalSupply = 0;\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof\n', '    // function balanceOf(address _owner) constant returns (uint256 balance)\n', '    mapping(address => uint256) public balanceOf;\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance\n', '    // function allowance(address _owner, address _spender) constant returns (uint256 remaining)\n', '    mapping(address => mapping(address => uint256)) public allowance;\n', '\n', '    /* --- administrative variables  */\n', '\n', '    // admins\n', '    mapping(address => bool) public isAdmin;\n', '\n', '    // addresses allowed to mint tokens:\n', '    mapping(address => bool) public canMint;\n', '\n', "    // addresses allowed to transfer tokens from contract's own address:\n", '    mapping(address => bool) public canTransferFromContract;\n', '\n', "    // addresses allowed to burn tokens (on contract's own address):\n", '    mapping(address => bool) public canBurn;\n', '\n', '    /* ---------- Constructor */\n', '    // do not forget about:\n', '    // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a\n', '    constructor() public {// Constructor must be public or internal\n', '        isAdmin[msg.sender] = true;\n', '        canMint[msg.sender] = true;\n', '        canTransferFromContract[msg.sender] = true;\n', '        canBurn[msg.sender] = true;\n', '    }\n', '\n', '    /* --- ERC-20 events */\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /* --- Interaction with other contracts events */\n', '    event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);\n', '\n', '    /* --- ERC-20 Functions */\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer\n', '    function transfer(address _to, uint256 _value) public returns (bool){\n', '        return transferFrom(msg.sender, _to, _value);\n', '    }\n', '\n', '    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool){\n', '\n', '        // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)\n', '        require(_value >= 0);\n', '\n', '        // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism\n', '        require(msg.sender == _from || _value <= allowance[_from][msg.sender] || (_from == address(this) && canTransferFromContract[msg.sender]));\n', '\n', '        // check if _from account have required amount\n', '        require(_value <= balanceOf[_from]);\n', '\n', '        if (_to == address(this)) {\n', '            // (!) only token holder can send tokens to smart contract to get fiat, not using allowance\n', '            require(_from == msg.sender);\n', '        }\n', '\n', '        balanceOf[_from] = balanceOf[_from].sub(_value);\n', '        balanceOf[_to] = balanceOf[_to].add(_value);\n', '\n', '        // If allowance used, change allowances correspondingly\n', '        if (_from != msg.sender && _from != address(this)) {\n', '            allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);\n', '        }\n', '\n', '        if (_to == address(this) && _value > 0) {\n', '\n', '            require(_value >= minExchangeAmount);\n', '\n', '            tokensInEventsCounter++;\n', '            tokensInTransfer[tokensInEventsCounter].from = _from;\n', '            tokensInTransfer[tokensInEventsCounter].value = _value;\n', '            tokensInTransfer[tokensInEventsCounter].receivedOn = now;\n', '\n', '            emit TokensIn(\n', '                _from,\n', '                _value,\n', '                tokensInEventsCounter\n', '            );\n', '        }\n', '\n', '        emit Transfer(_from, _to, _value);\n', '\n', '        return true;\n', '    }\n', '\n', '    /*  ---------- Interaction with other contracts  */\n', '\n', '    /* https://github.com/ethereum/EIPs/issues/677\n', '    * transfer tokens with additional info to another smart contract, and calls its correspondent function\n', '    * @param address _to - another smart contract address\n', '    * @param uint256 _value - number of tokens\n', '    * @param bytes _extraData - data to send to another contract\n', '    * > this may be used to convert pre-ICO tokens to ICO tokens\n', '    */\n', '    function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool){\n', '\n', '        tokenRecipient receiver = tokenRecipient(_to);\n', '\n', '        if (transferFrom(msg.sender, _to, _value)) {\n', '\n', '            if (receiver.tokenFallback(msg.sender, _value, _extraData)) {\n', '\n', '                emit DataSentToAnotherContract(msg.sender, _to, _extraData);\n', '\n', '                return true;\n', '\n', '            }\n', '\n', '        }\n', '        return false;\n', '    }\n', '\n', '    // the same as above, but for all tokens on user account\n', '    // for example for converting ALL tokens of user account to another tokens\n', '    function transferAllAndCall(address _to, bytes memory _extraData) public returns (bool){\n', '        return transferAndCall(_to, balanceOf[msg.sender], _extraData);\n', '    }\n', '\n', '    /* --- Administrative functions */\n', '\n', '    /* --- isAdmin */\n', '    event AdminAdded(address indexed by, address indexed newAdmin);//\n', '    function addAdmin(address _newAdmin) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        isAdmin[_newAdmin] = true;\n', '        emit AdminAdded(msg.sender, _newAdmin);\n', '        return true;\n', '    } //\n', '    event AdminRemoved(address indexed by, address indexed _oldAdmin);//\n', '    function removeAdmin(address _oldAdmin) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        // prevents from deleting the last admin (can be multisig smart contract) by itself:\n', '        require(msg.sender != _oldAdmin);\n', '        isAdmin[_oldAdmin] = false;\n', '        emit AdminRemoved(msg.sender, _oldAdmin);\n', '        return true;\n', '    }\n', '\n', '    uint256 minExchangeAmount = 12; // xEuro tokens\n', '    event minExchangeAmountChanged (address indexed by, uint256 from, uint256 to); //\n', '    function changeMinExchangeAmount(uint256 _minExchangeAmount) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        uint256 from = minExchangeAmount;\n', '        minExchangeAmount = _minExchangeAmount;\n', '        emit minExchangeAmountChanged(msg.sender, from, minExchangeAmount);\n', '        return true;\n', '    }\n', '\n', '    /* --- canMint */\n', '    event AddressAddedToCanMint(address indexed by, address indexed newAddress); //\n', '    function addToCanMint(address _newAddress) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canMint[_newAddress] = true;\n', '        emit AddressAddedToCanMint(msg.sender, _newAddress);\n', '        return true;\n', '    }//\n', '    event AddressRemovedFromCanMint(address indexed by, address indexed removedAddress);//\n', '    function removeFromCanMint(address _addressToRemove) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canMint[_addressToRemove] = false;\n', '        emit AddressRemovedFromCanMint(msg.sender, _addressToRemove);\n', '        return true;\n', '    }\n', '\n', '    /* --- canTransferFromContract*/\n', '    event AddressAddedToCanTransferFromContract(address indexed by, address indexed newAddress); //\n', '    function addToCanTransferFromContract(address _newAddress) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canTransferFromContract[_newAddress] = true;\n', '        emit AddressAddedToCanTransferFromContract(msg.sender, _newAddress);\n', '        return true;\n', '    }//\n', '    event AddressRemovedFromCanTransferFromContract(address indexed by, address indexed removedAddress);//\n', '    function removeFromCanTransferFromContract(address _addressToRemove) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canTransferFromContract[_addressToRemove] = false;\n', '        emit AddressRemovedFromCanTransferFromContract(msg.sender, _addressToRemove);\n', '        return true;\n', '    }\n', '\n', '    /* --- canBurn */\n', '    event AddressAddedToCanBurn(address indexed by, address indexed newAddress); //\n', '    function addToCanBurn(address _newAddress) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canBurn[_newAddress] = true;\n', '        emit AddressAddedToCanBurn(msg.sender, _newAddress);\n', '        return true;\n', '    }//\n', '    event AddressRemovedFromCanBurn(address indexed by, address indexed removedAddress);//\n', '    function removeFromCanBurn(address _addressToRemove) public returns (bool){\n', '        require(isAdmin[msg.sender]);\n', '\n', '        canBurn[_addressToRemove] = false;\n', '        emit AddressRemovedFromCanBurn(msg.sender, _addressToRemove);\n', '        return true;\n', '    }\n', '\n', '    /* ---------- Create and burn tokens  */\n', '\n', '    /* -- Accounting: exchange fiat to tokens (fiat sent to our bank acc with eth acc in reference > tokens ) */\n', '    uint public mintTokensEventsCounter = 0;//\n', '    struct MintTokensEvent {\n', '        address mintedBy; //\n', '        uint256 fiatInPaymentId;\n', '        uint value;   //\n', '        uint on;    // UnixTime\n', '        uint currentTotalSupply;\n', '    } //\n', '    //  keep all fiat tx ids, to prevent minting tokens twice (or more times) for the same fiat tx\n', '    mapping(uint256 => bool) public fiatInPaymentIds;\n', '\n', '    // here we can find a MintTokensEvent by fiatInPaymentId,\n', '    // so we now if tokens were minted for given incoming fiat payment\n', '    mapping(uint256 => MintTokensEvent) public fiatInPaymentsToMintTokensEvent;\n', '\n', '    // here we store MintTokensEvent with its ordinal numbers\n', '    mapping(uint256 => MintTokensEvent) public mintTokensEvent; //\n', '    event TokensMinted(\n', '        address indexed by,\n', '        uint256 indexed fiatInPaymentId,\n', '        uint value,\n', '        uint currentTotalSupply,\n', '        uint indexed mintTokensEventsCounter\n', '    );\n', '\n', '    // tokens should be minted to contracts own address, (!) after that tokens should be transferred using transferFrom\n', '    function mintTokens(uint256 value, uint256 fiatInPaymentId) public returns (bool){\n', '\n', '        require(canMint[msg.sender]);\n', '\n', '        // require that this fiatInPaymentId was not used before:\n', '        require(!fiatInPaymentIds[fiatInPaymentId]);\n', '\n', '        require(value >= 0);\n', '        // <<< this is the moment when new tokens appear in the system\n', '        totalSupply = totalSupply.add(value);\n', '        // first token holder of fresh minted tokens is the contract itself\n', '        balanceOf[address(this)] = balanceOf[address(this)].add(value);\n', '\n', '        mintTokensEventsCounter++;\n', '        mintTokensEvent[mintTokensEventsCounter].mintedBy = msg.sender;\n', '        mintTokensEvent[mintTokensEventsCounter].fiatInPaymentId = fiatInPaymentId;\n', '        mintTokensEvent[mintTokensEventsCounter].value = value;\n', '        mintTokensEvent[mintTokensEventsCounter].on = block.timestamp;\n', '        mintTokensEvent[mintTokensEventsCounter].currentTotalSupply = totalSupply;\n', '        //\n', '        fiatInPaymentsToMintTokensEvent[fiatInPaymentId] = mintTokensEvent[mintTokensEventsCounter];\n', '\n', '        emit TokensMinted(msg.sender, fiatInPaymentId, value, totalSupply, mintTokensEventsCounter);\n', '\n', '        fiatInPaymentIds[fiatInPaymentId] = true;\n', '\n', '        return true;\n', '\n', '    }\n', '\n', "    // requires msg.sender be both 'canMint' and 'canTransferFromContract'\n", '    function mintAndTransfer(\n', '        uint256 _value,\n', '        uint256 fiatInPaymentId,\n', '        address _to\n', '    ) public returns (bool){\n', '\n', '        if (mintTokens(_value, fiatInPaymentId) && transferFrom(address(this), _to, _value)) {\n', '            return true;\n', '        }\n', '        return false;\n', '    }\n', '\n', '    /* -- Accounting: exchange tokens to fiat (tokens sent to contract owns address > fiat payment) */\n', '    uint public tokensInEventsCounter = 0;//\n', "    struct TokensInTransfer {// <<< used in 'transfer'\n", '        address from; //\n', '        uint value;   //\n', '        uint receivedOn; // UnixTime\n', '    } //\n', '    mapping(uint256 => TokensInTransfer) public tokensInTransfer; //\n', '    event TokensIn(\n', '        address indexed from,\n', '        uint256 value,\n', '        uint256 indexed tokensInEventsCounter\n', '    );//\n', '\n', '    uint public burnTokensEventsCounter = 0;//\n', '    struct burnTokensEvent {\n', '        address by; //\n', '        uint256 value;   //\n', '        uint256 tokensInEventId;\n', '        uint256 fiatOutPaymentId;\n', '        uint256 burnedOn; // UnixTime\n', '        uint256 currentTotalSupply;\n', '    } //\n', '    mapping(uint => burnTokensEvent) public burnTokensEvents;\n', '\n', '    // we count every fiat payment id used when burn tokens to prevent using it twice\n', '    mapping(uint256 => bool) public fiatOutPaymentIdsUsed; //\n', '\n', '    event TokensBurned(\n', '        address indexed by,\n', '        uint256 value,\n', '        uint256 indexed tokensInEventId,\n', '        uint256 indexed fiatOutPaymentId,\n', '        uint burnedOn, // UnixTime\n', '        uint currentTotalSupply\n', '    );\n', '\n', "    // (!) only contract's own tokens (balanceOf[this]) can be burned\n", '    function burnTokens(\n', '        uint256 value,\n', '        uint256 tokensInEventId,\n', '        uint256 fiatOutPaymentId\n', '    ) public returns (bool){\n', '\n', '        require(canBurn[msg.sender]);\n', '\n', '        require(value >= 0);\n', '        require(balanceOf[address(this)] >= value);\n', '\n', '        // require(!tokensInEventIdsUsed[tokensInEventId]);\n', '        require(!fiatOutPaymentIdsUsed[fiatOutPaymentId]);\n', '\n', '        balanceOf[address(this)] = balanceOf[address(this)].sub(value);\n', '        totalSupply = totalSupply.sub(value);\n', '\n', '        burnTokensEventsCounter++;\n', '        burnTokensEvents[burnTokensEventsCounter].by = msg.sender;\n', '        burnTokensEvents[burnTokensEventsCounter].value = value;\n', '        burnTokensEvents[burnTokensEventsCounter].tokensInEventId = tokensInEventId;\n', '        burnTokensEvents[burnTokensEventsCounter].fiatOutPaymentId = fiatOutPaymentId;\n', '        burnTokensEvents[burnTokensEventsCounter].burnedOn = block.timestamp;\n', '        burnTokensEvents[burnTokensEventsCounter].currentTotalSupply = totalSupply;\n', '\n', '        emit TokensBurned(msg.sender, value, tokensInEventId, fiatOutPaymentId, block.timestamp, totalSupply);\n', '\n', '        fiatOutPaymentIdsUsed[fiatOutPaymentId];\n', '\n', '        return true;\n', '    }\n', '\n', '}']