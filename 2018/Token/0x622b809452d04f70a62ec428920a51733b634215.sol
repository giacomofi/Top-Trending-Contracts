['/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', 'pragma solidity 0.4.21;\n', '/// @title Utility Functions for address\n', '/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c9a2a6a7aea5a0a8a7ae89a5a6a6b9bba0a7aee7a6bbae">[email&#160;protected]</a>>\n', 'library StringUtil {\n', '    function stringToBytes12(string str)\n', '        internal\n', '        pure\n', '        returns (bytes12 result)\n', '    {\n', '        assembly {\n', '            result := mload(add(str, 32))\n', '        }\n', '    }\n', '    function stringToBytes10(string str)\n', '        internal\n', '        pure\n', '        returns (bytes10 result)\n', '    {\n', '        assembly {\n', '            result := mload(add(str, 32))\n', '        }\n', '    }\n', '    /// check length >= min && <= max\n', '    function checkStringLength(string name, uint min, uint max)\n', '        internal\n', '        pure\n', '        returns (bool)\n', '    {\n', '        bytes memory temp = bytes(name);\n', '        return temp.length >= min && temp.length <= max;\n', '    }\n', '}\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title Utility Functions for address\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="284c4946414d4468444747585a41464f06475a4f">[email&#160;protected]</a>>\n', 'library AddressUtil {\n', '    function isContract(\n', '        address addr\n', '        )\n', '        internal\n', '        view\n', '        returns (bool)\n', '    {\n', '        if (addr == 0x0) {\n', '            return false;\n', '        } else {\n', '            uint size;\n', '            assembly { size := extcodesize(addr) }\n', '            return size > 0;\n', '        }\n', '    }\n', '}\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/*\n', '    Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '    Licensed under the Apache License, Version 2.0 (the "License");\n', '    you may not use this file except in compliance with the License.\n', '    You may obtain a copy of the License at\n', '    http://www.apache.org/licenses/LICENSE-2.0\n', '    Unless required by applicable law or agreed to in writing, software\n', '    distributed under the License is distributed on an "AS IS" BASIS,\n', '    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '    See the License for the specific language governing permissions and\n', '    limitations under the License.\n', '*/\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title ERC20 Token Interface\n', '/// @dev see https://github.com/ethereum/EIPs/issues/20\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6f0b0e01060a032f0300001f1d06010841001d08">[email&#160;protected]</a>>\n', 'contract ERC20 {\n', '    function balanceOf(\n', '        address who\n', '        )\n', '        view\n', '        public\n', '        returns (uint256);\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '        )\n', '        view\n', '        public\n', '        returns (uint256);\n', '    function transfer(\n', '        address to,\n', '        uint256 value\n', '        )\n', '        public\n', '        returns (bool);\n', '    function transferFrom(\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '        )\n', '        public\n', '        returns (bool);\n', '    function approve(\n', '        address spender,\n', '        uint256 value\n', '        )\n', '        public\n', '        returns (bool);\n', '}\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title Utility Functions for uint\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="1a7e7b74737f765a7675756a6873747d3475687d">[email&#160;protected]</a>>\n', 'library MathUint {\n', '    function mul(\n', '        uint a,\n', '        uint b\n', '        )\n', '        internal\n', '        pure\n', '        returns (uint c)\n', '    {\n', '        c = a * b;\n', '        require(a == 0 || c / a == b);\n', '    }\n', '    function sub(\n', '        uint a,\n', '        uint b\n', '        )\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        require(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(\n', '        uint a,\n', '        uint b\n', '        )\n', '        internal\n', '        pure\n', '        returns (uint c)\n', '    {\n', '        c = a + b;\n', '        require(c >= a);\n', '    }\n', '    function tolerantSub(\n', '        uint a,\n', '        uint b\n', '        )\n', '        internal\n', '        pure\n', '        returns (uint c)\n', '    {\n', '        return (a >= b) ? a - b : 0;\n', '    }\n', '    /// @dev calculate the square of Coefficient of Variation (CV)\n', '    /// https://en.wikipedia.org/wiki/Coefficient_of_variation\n', '    function cvsquare(\n', '        uint[] arr,\n', '        uint scale\n', '        )\n', '        internal\n', '        pure\n', '        returns (uint)\n', '    {\n', '        uint len = arr.length;\n', '        require(len > 1);\n', '        require(scale > 0);\n', '        uint avg = 0;\n', '        for (uint i = 0; i < len; i++) {\n', '            avg += arr[i];\n', '        }\n', '        avg = avg / len;\n', '        if (avg == 0) {\n', '            return 0;\n', '        }\n', '        uint cvs = 0;\n', '        uint s;\n', '        uint item;\n', '        for (i = 0; i < len; i++) {\n', '            item = arr[i];\n', '            s = item > avg ? item - avg : avg - item;\n', '            cvs += mul(s, s);\n', '        }\n', '        return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);\n', '    }\n', '}\n', '/// @title ERC20 Token Implementation\n', '/// @dev see https://github.com/ethereum/EIPs/issues/20\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="0367626d6a666f436f6c6c73716a6d642d6c7164">[email&#160;protected]</a>>\n', 'contract ERC20Token is ERC20 {\n', '    using MathUint for uint;\n', '    string  public name;\n', '    string  public symbol;\n', '    uint8   public decimals;\n', '    uint    public totalSupply_;\n', '    mapping (address => uint256) balances;\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    function ERC20Token(\n', '        string  _name,\n', '        string  _symbol,\n', '        uint8   _decimals,\n', '        uint    _totalSupply,\n', '        address _firstHolder\n', '        )\n', '        public\n', '    {\n', '        require(_totalSupply > 0);\n', '        require(_firstHolder != 0x0);\n', '        checkSymbolAndName(_symbol,_name);\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = _decimals;\n', '        totalSupply_ = _totalSupply;\n', '        balances[_firstHolder] = totalSupply_;\n', '    }\n', '    function ()\n', '        payable\n', '        public\n', '    {\n', '        revert();\n', '    }\n', '    /**\n', '    * @dev total number of tokens in existence\n', '    */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return totalSupply_;\n', '    }\n', '    /**\n', '    * @dev transfer token for a specified address\n', '    * @param _to The address to transfer to.\n', '    * @param _value The amount to be transferred.\n', '    */\n', '    function transfer(\n', '        address _to,\n', '        uint256 _value\n', '        )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '    * @dev Gets the balance of the specified address.\n', '    * @param _owner The address to query the the balance of.\n', '    * @return An uint256 representing the amount owned by the passed address.\n', '    */\n', '    function balanceOf(\n', '        address _owner\n', '        )\n', '        public\n', '        view\n', '        returns (uint256 balance)\n', '    {\n', '        return balances[_owner];\n', '    }\n', '    /**\n', '     * @dev Transfer tokens from one address to another\n', '     * @param _from address The address which you want to send tokens from\n', '     * @param _to address The address which you want to transfer to\n', '     * @param _value uint256 the amount of tokens to be transferred\n', '     */\n', '    function transferFrom(\n', '        address _from,\n', '        address _to,\n', '        uint256 _value\n', '        )\n', '        public\n', '        returns (bool)\n', '    {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.\n', '     *\n', '     * Beware that changing an allowance with this method brings the risk that someone may use both the old\n', '     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this\n', '     * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _value The amount of tokens to be spent.\n', '     */\n', '    function approve(\n', '        address _spender,\n', '        uint256 _value\n', '        )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Function to check the amount of tokens that an owner allowed to a spender.\n', '     * @param _owner address The address which owns the funds.\n', '     * @param _spender address The address which will spend the funds.\n', '     * @return A uint256 specifying the amount of tokens still available for the spender.\n', '     */\n', '    function allowance(\n', '        address _owner,\n', '        address _spender\n', '        )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    /**\n', '     * @dev Increase the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To increment\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _addedValue The amount of tokens to increase the allowance by.\n', '     */\n', '    function increaseApproval(\n', '        address _spender,\n', '        uint _addedValue\n', '        )\n', '        public\n', '        returns (bool)\n', '    {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    /**\n', '     * @dev Decrease the amount of tokens that an owner allowed to a spender.\n', '     *\n', '     * approve should be called when allowed[_spender] == 0. To decrement\n', '     * allowed value is better to use this function to avoid 2 calls (and wait until\n', '     * the first transaction is mined)\n', '     * From MonolithDAO Token.sol\n', '     * @param _spender The address which will spend the funds.\n', '     * @param _subtractedValue The amount of tokens to decrease the allowance by.\n', '     */\n', '    function decreaseApproval(\n', '        address _spender,\n', '        uint _subtractedValue\n', '        )\n', '        public\n', '        returns (bool)\n', '    {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    // Make sure symbol has 3-8 chars in [A-Za-z._] and name has up to 128 chars.\n', '    function checkSymbolAndName(\n', '        string memory _symbol,\n', '        string memory _name\n', '        )\n', '        internal\n', '        pure\n', '    {\n', '        bytes memory s = bytes(_symbol);\n', '        require(s.length >= 3 && s.length <= 8);\n', '        for (uint i = 0; i < s.length; i++) {\n', '            require(\n', '                s[i] == 0x2E ||  // "."\n', '                s[i] == 0x5F ||  // "_"\n', '                s[i] >= 0x41 && s[i] <= 0x5A ||  // [A-Z]\n', '                s[i] >= 0x61 && s[i] <= 0x7A     // [a-z]\n', '            );\n', '        }\n', '        bytes memory n = bytes(_name);\n', '        require(n.length >= s.length && n.length <= 128);\n', '        for (i = 0; i < n.length; i++) {\n', '            require(n[i] >= 0x20 && n[i] <= 0x7E);\n', '        }\n', '    }\n', '}\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title ERC20 Token Mint\n', '/// @dev This contract deploys ERC20 token contract and registered the contract\n', '///      so the token can be traded with Loopring Protocol.\n', '/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="583337363f343139363f18343737282a31363f76372a3f">[email&#160;protected]</a>>,\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="0367626d6a666f436f6c6c73716a6d642d6c7164">[email&#160;protected]</a>>.\n', 'contract TokenFactory {\n', '    event TokenCreated(\n', '        address indexed addr,\n', '        string  name,\n', '        string  symbol,\n', '        uint8   decimals,\n', '        uint    totalSupply,\n', '        address firstHolder\n', '    );\n', '    /// @dev Deploy an ERC20 token contract, register it with TokenRegistry,\n', '    ///      and returns the new token&#39;s address.\n', '    /// @param name The name of the token\n', '    /// @param symbol The symbol of the token.\n', '    /// @param decimals The decimals of the token.\n', '    /// @param totalSupply The total supply of the token.\n', '    function createToken(\n', '        string  name,\n', '        string  symbol,\n', '        uint8   decimals,\n', '        uint    totalSupply\n', '        )\n', '        external\n', '        returns (address addr);\n', '}\n', '/*\n', '  Copyright 2017 Loopring Project Ltd (Loopring Foundation).\n', '  Licensed under the Apache License, Version 2.0 (the "License");\n', '  you may not use this file except in compliance with the License.\n', '  You may obtain a copy of the License at\n', '  http://www.apache.org/licenses/LICENSE-2.0\n', '  Unless required by applicable law or agreed to in writing, software\n', '  distributed under the License is distributed on an "AS IS" BASIS,\n', '  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n', '  See the License for the specific language governing permissions and\n', '  limitations under the License.\n', '*/\n', '/// @title Token Register Contract\n', '/// @dev This contract maintains a list of tokens the Protocol supports.\n', '/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="214a4e4f464d48404f46614d4e4e5153484f460f4e5346">[email&#160;protected]</a>>,\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c1a5a0afa8a4ad81adaeaeb1b3a8afa6efaeb3a6">[email&#160;protected]</a>>.\n', 'contract TokenRegistry {\n', '    event TokenRegistered(address addr, string symbol);\n', '    event TokenUnregistered(address addr, string symbol);\n', '    function registerToken(\n', '        address addr,\n', '        string  symbol\n', '        )\n', '        external;\n', '    function registerMintedToken(\n', '        address addr,\n', '        string  symbol\n', '        )\n', '        external;\n', '    function unregisterToken(\n', '        address addr,\n', '        string  symbol\n', '        )\n', '        external;\n', '    function areAllTokensRegistered(\n', '        address[] addressList\n', '        )\n', '        external\n', '        view\n', '        returns (bool);\n', '    function getAddressBySymbol(\n', '        string symbol\n', '        )\n', '        external\n', '        view\n', '        returns (address);\n', '    function isTokenRegisteredBySymbol(\n', '        string symbol\n', '        )\n', '        public\n', '        view\n', '        returns (bool);\n', '    function isTokenRegistered(\n', '        address addr\n', '        )\n', '        public\n', '        view\n', '        returns (bool);\n', '    function getTokens(\n', '        uint start,\n', '        uint count\n', '        )\n', '        public\n', '        view\n', '        returns (address[] addressList);\n', '}\n', '/// @title An Implementation of TokenFactory.\n', '/// @author Kongliang Zhong - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b4dfdbdad3d8ddd5dad3f4d8dbdbc4c6dddad39adbc6d3">[email&#160;protected]</a>>,\n', '/// @author Daniel Wang - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="7115101f18141d311d1e1e0103181f165f1e0316">[email&#160;protected]</a>>.\n', 'contract TokenFactoryImpl is TokenFactory {\n', '    using AddressUtil for address;\n', '    using StringUtil for string;\n', '    mapping(bytes10 => address) public tokens;\n', '    address   public tokenRegistry;\n', '    address   public tokenTransferDelegate;\n', '    /// @dev Disable default function.\n', '    function ()\n', '        payable\n', '        public\n', '    {\n', '        revert();\n', '    }\n', '    function TokenFactoryImpl(\n', '        address _tokenRegistry\n', '        )\n', '        public\n', '    {\n', '        require(tokenRegistry == 0x0 && _tokenRegistry.isContract());\n', '        tokenRegistry = _tokenRegistry;\n', '    }\n', '    function createToken(\n', '        string  name,\n', '        string  symbol,\n', '        uint8   decimals,\n', '        uint    totalSupply\n', '        )\n', '        external\n', '        returns (address addr)\n', '    {\n', '        require(tokenRegistry != 0x0);\n', '        require(tokenTransferDelegate != 0x0);\n', '        require(symbol.checkStringLength(3, 10));\n', '        bytes10 symbolBytes = symbol.stringToBytes10();\n', '        require(tokens[symbolBytes] == 0x0);\n', '        ERC20Token token = new ERC20Token(\n', '            name,\n', '            symbol,\n', '            decimals,\n', '            totalSupply,\n', '            tx.origin\n', '        );\n', '        addr = address(token);\n', '        TokenRegistry(tokenRegistry).registerMintedToken(addr, symbol);\n', '        tokens[symbolBytes] = addr;\n', '        emit TokenCreated(\n', '            addr,\n', '            name,\n', '            symbol,\n', '            decimals,\n', '            totalSupply,\n', '            tx.origin\n', '        );\n', '    }\n', '}']