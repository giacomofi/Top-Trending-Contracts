['/*\n', 'B.PROTOCOL TERMS OF USE\n', '=======================\n', '\n', 'THE TERMS OF USE CONTAINED HEREIN (THESE “TERMS”) GOVERN YOUR USE OF B.PROTOCOL, WHICH IS A DECENTRALIZED PROTOCOL ON THE ETHEREUM BLOCKCHAIN (the “PROTOCOL”) THAT enables a backstop liquidity mechanism FOR DECENTRALIZED LENDING PLATFORMS\xa0(“DLPs”).  \n', 'PLEASE READ THESE TERMS CAREFULLY AT https://github.com/backstop-protocol/Terms-and-Conditions, INCLUDING ALL DISCLAIMERS AND RISK FACTORS, BEFORE USING THE PROTOCOL. BY USING THE PROTOCOL, YOU ARE IRREVOCABLY CONSENTING TO BE BOUND BY THESE TERMS. \n', 'IF YOU DO NOT AGREE TO ALL OF THESE TERMS, DO NOT USE THE PROTOCOL. YOUR RIGHT TO USE THE PROTOCOL IS SUBJECT AND DEPENDENT BY YOUR AGREEMENT TO ALL TERMS AND CONDITIONS SET FORTH HEREIN, WHICH AGREEMENT SHALL BE EVIDENCED BY YOUR USE OF THE PROTOCOL.\n', 'Minors Prohibited: The Protocol is not directed to individuals under the age of eighteen (18) or the age of majority in your jurisdiction if the age of majority is greater. If you are under the age of eighteen or the age of majority (if greater), you are not authorized to access or use the Protocol. By using the Protocol, you represent and warrant that you are above such age.\n', '\n', 'License; No Warranties; Limitation of Liability;\n', '(a) The software underlying the Protocol is licensed for use in accordance with the 3-clause BSD License, which can be accessed here: https://opensource.org/licenses/BSD-3-Clause.\n', '(b) THE PROTOCOL IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS", “WITH ALL FAULTS” and “AS AVAILABLE” AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. \n', '(c) IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. \n', '*/\n', 'pragma solidity ^0.5.12;\n', '\n', 'interface DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) external view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    constructor() public {\n', '        owner = msg.sender;\n', '        emit LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '        public\n', '        auth\n', '    {\n', '        owner = owner_;\n', '        emit LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '        public\n', '        auth\n', '    {\n', '        authority = authority_;\n', '        emit LogSetAuthority(address(authority));\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, address(this), sig);\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'interface OSMLike {\n', '    function peep() external view returns (bytes32, bool);\n', '    function hop()  external view returns(uint16);\n', '    function zzz()  external view returns(uint64);\n', '}\n', '\n', 'interface PipLike {\n', '    function read() external view returns (bytes32);\n', '}\n', '\n', 'contract BudConnector is DSAuth {\n', '\n', '    mapping(address => bool) public authorized;\n', '    OSMLike public osm;\n', '    mapping(bytes32 => PipLike) pips;\n', '\n', '    constructor(OSMLike osm_) public {\n', '        osm = osm_;\n', '    }\n', '\n', '    function authorize(address addr) external auth {\n', '        authorized[addr] = true;\n', '    }\n', '\n', '    function setPip(address pip, bytes32 ilk) external auth {\n', '        require(pips[ilk] == PipLike(0), "ilk-already-init");\n', '        pips[ilk] = PipLike(pip);\n', '    }\n', '\n', '    function peep() external view returns (bytes32, bool) {\n', '        require(authorized[msg.sender], "!authorized");\n', '        return osm.peep();\n', '    }\n', '\n', '    function read(bytes32 ilk) external view returns (bytes32) {\n', '        require(authorized[msg.sender], "!authorized");\n', '        return pips[ilk].read();\n', '    }\n', '\n', '    function hop() external view returns(uint16) {\n', '        return osm.hop();\n', '    }\n', '\n', '    function zzz() external view returns(uint64) {\n', '        return osm.zzz();\n', '    }\n', '}']