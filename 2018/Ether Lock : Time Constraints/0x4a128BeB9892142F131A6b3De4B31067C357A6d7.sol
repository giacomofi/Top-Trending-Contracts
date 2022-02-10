['contract TokenController {\n', '    /// @notice Called when `_owner` sends ether to the MiniMe Token contract\n', '    /// @param _owner The address that sent the ether to create tokens\n', '    /// @return True if the ether is accepted, false if it throws\n', '    function proxyPayment(address _owner) payable returns(bool);\n', '\n', '    /// @notice Notifies the controller about a token transfer allowing the\n', '    ///  controller to react if desired\n', '    /// @param _from The origin of the transfer\n', '    /// @param _to The destination of the transfer\n', '    /// @param _amount The amount of the transfer\n', '    /// @return False if the controller does not authorize the transfer\n', '    function onTransfer(address _from, address _to, uint _amount) returns(bool);\n', '\n', '    /// @notice Notifies the controller about an approval allowing the\n', '    ///  controller to react if desired\n', '    /// @param _owner The address that calls `approve()`\n', '    /// @param _spender The spender in the `approve()` call\n', '    /// @param _amount The amount in the `approve()` call\n', '    /// @return False if the controller does not authorize the approval\n', '    function onApprove(address _owner, address _spender, uint _amount)\n', '        returns(bool);\n', '}\n', '\n', 'contract Controlled {\n', '    /// @notice The address of the controller is the only address that can call\n', '    ///  a function with this modifier\n', '    modifier onlyController { require(msg.sender == controller); _; }\n', '\n', '    address public controller;\n', '\n', '    function Controlled() { controller = msg.sender;}\n', '\n', '    /// @notice Changes the controller of the contract\n', '    /// @param _newController The new controller of the contract\n', '    function changeController(address _newController) onlyController {\n', '        controller = _newController;\n', '    }\n', '}\n', '\n', 'contract ApproveAndCallFallBack {\n', '    function receiveApproval(address from, uint256 _amount, address _token, bytes _data);\n', '}\n', '\n', '/// @dev The actual token contract, the default controller is the msg.sender\n', '///  that deploys the contract, so usually this token will be deployed by a\n', '///  token controller contract, which Giveth will call a "Campaign"\n', 'contract MiniMeToken is Controlled {\n', '\n', "    string public name;                //The Token's name: e.g. DigixDAO Tokens\n", '    uint8 public decimals;             //Number of decimals of the smallest unit\n', '    string public symbol;              //An identifier: e.g. REP\n', "    string public version = 'MMT_0.1'; //An arbitrary versioning scheme\n", '\n', '\n', '    /// @dev `Checkpoint` is the structure that attaches a block number to a\n', '    ///  given value, the block number attached is the one that last changed the\n', '    ///  value\n', '    struct  Checkpoint {\n', '\n', '        // `fromBlock` is the block number that the value was generated from\n', '        uint128 fromBlock;\n', '\n', '        // `value` is the amount of tokens at a specific block number\n', '        uint128 value;\n', '    }\n', '\n', '    // `parentToken` is the Token address that was cloned to produce this token;\n', '    //  it will be 0x0 for a token that was not cloned\n', '    MiniMeToken public parentToken;\n', '\n', '    // `parentSnapShotBlock` is the block number from the Parent Token that was\n', '    //  used to determine the initial distribution of the Clone Token\n', '    uint public parentSnapShotBlock;\n', '\n', '    // `creationBlock` is the block number that the Clone Token was created\n', '    uint public creationBlock;\n', '\n', '    // `balances` is the map that tracks the balance of each address, in this\n', '    //  contract when the balance changes the block number that the change\n', '    //  occurred is also included in the map\n', '    mapping (address => Checkpoint[]) balances;\n', '\n', '    // `allowed` tracks any extra transfer rights as in all ERC20 tokens\n', '    mapping (address => mapping (address => uint256)) allowed;\n', '\n', '    // Tracks the history of the `totalSupply` of the token\n', '    Checkpoint[] totalSupplyHistory;\n', '\n', '    // Flag that determines if the token is transferable or not.\n', '    bool public transfersEnabled;\n', '\n', '    // The factory used to create new clone tokens\n', '    MiniMeTokenFactory public tokenFactory;\n', '\n', '////////////////\n', '// Constructor\n', '////////////////\n', '\n', '    /// @notice Constructor to create a MiniMeToken\n', '    /// @param _tokenFactory The address of the MiniMeTokenFactory contract that\n', '    ///  will create the Clone token contracts, the token factory needs to be\n', '    ///  deployed first\n', '    /// @param _parentToken Address of the parent token, set to 0x0 if it is a\n', '    ///  new token\n', '    /// @param _parentSnapShotBlock Block of the parent token that will\n', '    ///  determine the initial distribution of the clone token, set to 0 if it\n', '    ///  is a new token\n', '    /// @param _tokenName Name of the new token\n', '    /// @param _decimalUnits Number of decimals of the new token\n', '    /// @param _tokenSymbol Token Symbol for the new token\n', '    /// @param _transfersEnabled If true, tokens will be able to be transferred\n', '    function MiniMeToken(\n', '        address _tokenFactory,\n', '        address _parentToken,\n', '        uint _parentSnapShotBlock,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol,\n', '        bool _transfersEnabled\n', '    ) {\n', '        tokenFactory = MiniMeTokenFactory(_tokenFactory);\n', '        name = _tokenName;                                 // Set the name\n', '        decimals = _decimalUnits;                          // Set the decimals\n', '        symbol = _tokenSymbol;                             // Set the symbol\n', '        parentToken = MiniMeToken(_parentToken);\n', '        parentSnapShotBlock = _parentSnapShotBlock;\n', '        transfersEnabled = _transfersEnabled;\n', '        creationBlock = block.number;\n', '    }\n', '\n', '\n', '///////////////////\n', '// ERC20 Methods\n', '///////////////////\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _amount) returns (bool success) {\n', '        require(transfersEnabled);\n', '        return doTransfer(msg.sender, _to, _amount);\n', '    }\n', '\n', '    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it\n', '    ///  is approved by `_from`\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function transferFrom(address _from, address _to, uint256 _amount\n', '    ) returns (bool success) {\n', '\n', '        // The controller of this contract can move tokens around at will,\n', '        //  this is important to recognize! Confirm that you trust the\n', '        //  controller of this contract, which in most situations should be\n', '        //  another open source smart contract or 0x0\n', '        if (msg.sender != controller) {\n', '            require(transfersEnabled);\n', '\n', '            // The standard ERC 20 transferFrom functionality\n', '            if (allowed[_from][msg.sender] < _amount) return false;\n', '            allowed[_from][msg.sender] -= _amount;\n', '        }\n', '        return doTransfer(_from, _to, _amount);\n', '    }\n', '\n', '    /// @dev This is the actual transfer function in the token contract, it can\n', '    ///  only be called by other functions in this contract.\n', '    /// @param _from The address holding the tokens being transferred\n', '    /// @param _to The address of the recipient\n', '    /// @param _amount The amount of tokens to be transferred\n', '    /// @return True if the transfer was successful\n', '    function doTransfer(address _from, address _to, uint _amount\n', '    ) internal returns(bool) {\n', '\n', '           if (_amount == 0) {\n', '               return true;\n', '           }\n', '\n', '           require(parentSnapShotBlock < block.number);\n', '\n', '           // Do not allow transfer to 0x0 or the token contract itself\n', '           require((_to != 0) && (_to != address(this)));\n', '\n', '           // If the amount being transfered is more than the balance of the\n', '           //  account the transfer returns false\n', '           var previousBalanceFrom = balanceOfAt(_from, block.number);\n', '           if (previousBalanceFrom < _amount) {\n', '               return false;\n', '           }\n', '\n', '           // Alerts the token controller of the transfer\n', '           if (isContract(controller)) {\n', '               require(TokenController(controller).onTransfer(_from, _to, _amount));\n', '           }\n', '\n', '           // First update the balance array with the new value for the address\n', '           //  sending the tokens\n', '           updateValueAtNow(balances[_from], previousBalanceFrom - _amount);\n', '\n', '           // Then update the balance array with the new value for the address\n', '           //  receiving the tokens\n', '           var previousBalanceTo = balanceOfAt(_to, block.number);\n', '           require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '           updateValueAtNow(balances[_to], previousBalanceTo + _amount);\n', '\n', '           // An event to make the transfer easy to find on the blockchain\n', '           Transfer(_from, _to, _amount);\n', '\n', '           return true;\n', '    }\n', '\n', "    /// @param _owner The address that's balance is being requested\n", '    /// @return The balance of `_owner` at the current block\n', '    function balanceOf(address _owner) constant returns (uint256 balance) {\n', '        return balanceOfAt(_owner, block.number);\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on\n', '    ///  its behalf. This is a modified version of the ERC20 approve function\n', '    ///  to be a little bit safer\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the approval was successful\n', '    function approve(address _spender, uint256 _amount) returns (bool success) {\n', '        require(transfersEnabled);\n', '\n', '        // To change the approve amount you first have to reduce the addresses`\n', '        //  allowance to zero by calling `approve(_spender,0)` if it is not\n', '        //  already 0 to mitigate the race condition described here:\n', '        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));\n', '\n', '        // Alerts the token controller of the approve function call\n', '        if (isContract(controller)) {\n', '            require(TokenController(controller).onApprove(msg.sender, _spender, _amount));\n', '        }\n', '\n', '        allowed[msg.sender][_spender] = _amount;\n', '        Approval(msg.sender, _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    /// @dev This function makes it easy to read the `allowed[]` map\n', '    /// @param _owner The address of the account that owns the token\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens of _owner that _spender is allowed\n', '    ///  to spend\n', '    function allowance(address _owner, address _spender\n', '    ) constant returns (uint256 remaining) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on\n', '    ///  its behalf, and then a function is triggered in the contract that is\n', '    ///  being approved, `_spender`. This allows users to use their tokens to\n', '    ///  interact with contracts in one function call instead of two\n', '    /// @param _spender The address of the contract able to transfer the tokens\n', '    /// @param _amount The amount of tokens to be approved for transfer\n', '    /// @return True if the function call was successful\n', '    function approveAndCall(address _spender, uint256 _amount, bytes _extraData\n', '    ) returns (bool success) {\n', '        require(approve(_spender, _amount));\n', '\n', '        ApproveAndCallFallBack(_spender).receiveApproval(\n', '            msg.sender,\n', '            _amount,\n', '            this,\n', '            _extraData\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    /// @dev This function makes it easy to get the total number of tokens\n', '    /// @return The total number of tokens\n', '    function totalSupply() constant returns (uint) {\n', '        return totalSupplyAt(block.number);\n', '    }\n', '\n', '\n', '////////////////\n', '// Query balance and totalSupply in History\n', '////////////////\n', '\n', '    /// @dev Queries the balance of `_owner` at a specific `_blockNumber`\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @param _blockNumber The block number when the balance is queried\n', '    /// @return The balance at `_blockNumber`\n', '    function balanceOfAt(address _owner, uint _blockNumber) constant\n', '        returns (uint) {\n', '\n', '        // These next few lines are used when the balance of the token is\n', '        //  requested before a check point was ever created for this token, it\n', '        //  requires that the `parentToken.balanceOfAt` be queried at the\n', '        //  genesis block for that token as this contains initial balance of\n', '        //  this token\n', '        if ((balances[_owner].length == 0)\n', '            || (balances[_owner][0].fromBlock > _blockNumber)) {\n', '            if (address(parentToken) != 0) {\n', '                return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));\n', '            } else {\n', '                // Has no parent\n', '                return 0;\n', '            }\n', '\n', '        // This will return the expected balance during normal situations\n', '        } else {\n', '            return getValueAt(balances[_owner], _blockNumber);\n', '        }\n', '    }\n', '\n', '    /// @notice Total amount of tokens at a specific `_blockNumber`.\n', '    /// @param _blockNumber The block number when the totalSupply is queried\n', '    /// @return The total amount of tokens at `_blockNumber`\n', '    function totalSupplyAt(uint _blockNumber) constant returns(uint) {\n', '\n', '        // These next few lines are used when the totalSupply of the token is\n', '        //  requested before a check point was ever created for this token, it\n', '        //  requires that the `parentToken.totalSupplyAt` be queried at the\n', '        //  genesis block for this token as that contains totalSupply of this\n', '        //  token at this block number.\n', '        if ((totalSupplyHistory.length == 0)\n', '            || (totalSupplyHistory[0].fromBlock > _blockNumber)) {\n', '            if (address(parentToken) != 0) {\n', '                return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));\n', '            } else {\n', '                return 0;\n', '            }\n', '\n', '        // This will return the expected totalSupply during normal situations\n', '        } else {\n', '            return getValueAt(totalSupplyHistory, _blockNumber);\n', '        }\n', '    }\n', '\n', '////////////////\n', '// Clone Token Method\n', '////////////////\n', '\n', '    /// @notice Creates a new clone token with the initial distribution being\n', '    ///  this token at `_snapshotBlock`\n', '    /// @param _cloneTokenName Name of the clone token\n', '    /// @param _cloneDecimalUnits Number of decimals of the smallest unit\n', '    /// @param _cloneTokenSymbol Symbol of the clone token\n', '    /// @param _snapshotBlock Block when the distribution of the parent token is\n', '    ///  copied to set the initial distribution of the new clone token;\n', '    ///  if the block is zero than the actual block, the current block is used\n', '    /// @param _transfersEnabled True if transfers are allowed in the clone\n', '    /// @return The address of the new MiniMeToken Contract\n', '    function createCloneToken(\n', '        string _cloneTokenName,\n', '        uint8 _cloneDecimalUnits,\n', '        string _cloneTokenSymbol,\n', '        uint _snapshotBlock,\n', '        bool _transfersEnabled\n', '        ) returns(address) {\n', '        if (_snapshotBlock == 0) _snapshotBlock = block.number;\n', '        MiniMeToken cloneToken = tokenFactory.createCloneToken(\n', '            this,\n', '            _snapshotBlock,\n', '            _cloneTokenName,\n', '            _cloneDecimalUnits,\n', '            _cloneTokenSymbol,\n', '            _transfersEnabled\n', '            );\n', '\n', '        cloneToken.changeController(msg.sender);\n', '\n', '        // An event to make the token easy to find on the blockchain\n', '        NewCloneToken(address(cloneToken), _snapshotBlock);\n', '        return address(cloneToken);\n', '    }\n', '\n', '////////////////\n', '// Generate and destroy tokens\n', '////////////////\n', '\n', '    /// @notice Generates `_amount` tokens that are assigned to `_owner`\n', '    /// @param _owner The address that will be assigned the new tokens\n', '    /// @param _amount The quantity of tokens generated\n', '    /// @return True if the tokens are generated correctly\n', '    function generateTokens(address _owner, uint _amount\n', '    ) onlyController returns (bool) {\n', '        uint curTotalSupply = totalSupply();\n', '        require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow\n', '        uint previousBalanceTo = balanceOf(_owner);\n', '        require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow\n', '        updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);\n', '        updateValueAtNow(balances[_owner], previousBalanceTo + _amount);\n', '        Transfer(0, _owner, _amount);\n', '        return true;\n', '    }\n', '\n', '\n', '    /// @notice Burns `_amount` tokens from `_owner`\n', '    /// @param _owner The address that will lose the tokens\n', '    /// @param _amount The quantity of tokens to burn\n', '    /// @return True if the tokens are burned correctly\n', '    function destroyTokens(address _owner, uint _amount\n', '    ) onlyController returns (bool) {\n', '        uint curTotalSupply = totalSupply();\n', '        require(curTotalSupply >= _amount);\n', '        uint previousBalanceFrom = balanceOf(_owner);\n', '        require(previousBalanceFrom >= _amount);\n', '        updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);\n', '        updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);\n', '        Transfer(_owner, 0, _amount);\n', '        return true;\n', '    }\n', '\n', '////////////////\n', '// Enable tokens transfers\n', '////////////////\n', '\n', '\n', '    /// @notice Enables token holders to transfer their tokens freely if true\n', '    /// @param _transfersEnabled True if transfers are allowed in the clone\n', '    function enableTransfers(bool _transfersEnabled) onlyController {\n', '        transfersEnabled = _transfersEnabled;\n', '    }\n', '\n', '////////////////\n', '// Internal helper functions to query and set a value in a snapshot array\n', '////////////////\n', '\n', '    /// @dev `getValueAt` retrieves the number of tokens at a given block number\n', '    /// @param checkpoints The history of values being queried\n', '    /// @param _block The block number to retrieve the value at\n', '    /// @return The number of tokens being queried\n', '    function getValueAt(Checkpoint[] storage checkpoints, uint _block\n', '    ) constant internal returns (uint) {\n', '        if (checkpoints.length == 0) return 0;\n', '\n', '        // Shortcut for the actual value\n', '        if (_block >= checkpoints[checkpoints.length-1].fromBlock)\n', '            return checkpoints[checkpoints.length-1].value;\n', '        if (_block < checkpoints[0].fromBlock) return 0;\n', '\n', '        // Binary search of the value in the array\n', '        uint min = 0;\n', '        uint max = checkpoints.length-1;\n', '        while (max > min) {\n', '            uint mid = (max + min + 1)/ 2;\n', '            if (checkpoints[mid].fromBlock<=_block) {\n', '                min = mid;\n', '            } else {\n', '                max = mid-1;\n', '            }\n', '        }\n', '        return checkpoints[min].value;\n', '    }\n', '\n', '    /// @dev `updateValueAtNow` used to update the `balances` map and the\n', '    ///  `totalSupplyHistory`\n', '    /// @param checkpoints The history of data being updated\n', '    /// @param _value The new number of tokens\n', '    function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value\n', '    ) internal  {\n', '        if ((checkpoints.length == 0)\n', '        || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {\n', '               Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];\n', '               newCheckPoint.fromBlock =  uint128(block.number);\n', '               newCheckPoint.value = uint128(_value);\n', '           } else {\n', '               Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];\n', '               oldCheckPoint.value = uint128(_value);\n', '           }\n', '    }\n', '\n', '    /// @dev Internal function to determine if an address is a contract\n', '    /// @param _addr The address being queried\n', '    /// @return True if `_addr` is a contract\n', '    function isContract(address _addr) constant internal returns(bool) {\n', '        uint size;\n', '        if (_addr == 0) return false;\n', '        assembly {\n', '            size := extcodesize(_addr)\n', '        }\n', '        return size>0;\n', '    }\n', '\n', '    /// @dev Helper function to return a min betwen the two uints\n', '    function min(uint a, uint b) internal returns (uint) {\n', '        return a < b ? a : b;\n', '    }\n', '\n', "    /// @notice The fallback function: If the contract's controller has not been\n", '    ///  set to 0, then the `proxyPayment` method is called which relays the\n', '    ///  ether and creates tokens as described in the token controller contract\n', '    function ()  payable {\n', '        require(isContract(controller));\n', '        require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));\n', '    }\n', '\n', '//////////\n', '// Safety Methods\n', '//////////\n', '\n', '    /// @notice This method can be used by the controller to extract mistakenly\n', '    ///  sent tokens to this contract.\n', '    /// @param _token The address of the token contract that you want to recover\n', '    ///  set to 0 in case you want to extract ether.\n', '    function claimTokens(address _token) onlyController {\n', '        if (_token == 0x0) {\n', '            controller.transfer(this.balance);\n', '            return;\n', '        }\n', '\n', '        MiniMeToken token = MiniMeToken(_token);\n', '        uint balance = token.balanceOf(this);\n', '        token.transfer(controller, balance);\n', '        ClaimedTokens(_token, controller, balance);\n', '    }\n', '\n', '////////////////\n', '// Events\n', '////////////////\n', '    event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _amount);\n', '    event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);\n', '    event Approval(\n', '        address indexed _owner,\n', '        address indexed _spender,\n', '        uint256 _amount\n', '        );\n', '\n', '}\n', '\n', '\n', '////////////////\n', '// MiniMeTokenFactory\n', '////////////////\n', '\n', '/// @dev This contract is used to generate clone contracts from a contract.\n', '///  In solidity this is the way to create a contract from a contract of the\n', '///  same class\n', 'contract MiniMeTokenFactory {\n', '\n', '    /// @notice Update the DApp by creating a new token with new functionalities\n', '    ///  the msg.sender becomes the controller of this clone token\n', '    /// @param _parentToken Address of the token being cloned\n', '    /// @param _snapshotBlock Block of the parent token that will\n', '    ///  determine the initial distribution of the clone token\n', '    /// @param _tokenName Name of the new token\n', '    /// @param _decimalUnits Number of decimals of the new token\n', '    /// @param _tokenSymbol Token Symbol for the new token\n', '    /// @param _transfersEnabled If true, tokens will be able to be transferred\n', '    /// @return The address of the new token contract\n', '    function createCloneToken(\n', '        address _parentToken,\n', '        uint _snapshotBlock,\n', '        string _tokenName,\n', '        uint8 _decimalUnits,\n', '        string _tokenSymbol,\n', '        bool _transfersEnabled\n', '    ) returns (MiniMeToken) {\n', '        MiniMeToken newToken = new MiniMeToken(\n', '            this,\n', '            _parentToken,\n', '            _snapshotBlock,\n', '            _tokenName,\n', '            _decimalUnits,\n', '            _tokenSymbol,\n', '            _transfersEnabled\n', '            );\n', '\n', '        newToken.changeController(msg.sender);\n', '        return newToken;\n', '    }\n', '}\n', '\n', 'contract Token is MiniMeToken {\n', '    // @dev Token constructor just parametrizes the MiniMeIrrevocableVestedToken constructor\n', '    function Token(address _tokenFactory)\n', '    MiniMeToken(\n', '        _tokenFactory,\n', '        0x0,            // no parent token\n', '        0,              // no snapshot block number from parent\n', '        "Professional Activity Token",          // Token name\n', '        18,             // Decimals\n', '        "PATO",          // Symbol\n', '        true            // Enable transfers\n', '    ) {}\n', '}']