// SPDX-License-Identifier: MIT

/*
 * Created by Satoshi Nakajima (@snakajima)
 */

pragma solidity ^0.8.6;

import "./ProviderToken.sol";

abstract contract ProviderTokenEx is ProviderToken {
  uint256 public immutable tokensPerAsset;

  constructor(
    IAssetProvider _assetProvider,
    address _developer,
    IProxyRegistry _proxyRegistry,
    uint256 _tokensPerAsset,
    string memory _title,
    string memory _shortTitle
  ) ProviderToken(_assetProvider, _developer, _proxyRegistry, _title, _shortTitle) {
    tokensPerAsset = _tokensPerAsset;
  }

  /**
   */
  function mint(uint256 _affiliate) external {
    uint256 tokenId = _nextTokenId(); 
    _mint(msg.sender, tokensPerAsset - 1);

    // Specified affliate token must be one of the primary tokens and not owned by the minter.
    if (_affiliate > 0 && _isPrimary(_affiliate) && ownerOf(_affiliate) != msg.sender) {
      _mint(ownerOf(_affiliate), 1);
    } else if ((tokenId / tokensPerAsset) % 2 == 0) {
      // 1 in 20 tokens of non-affiliated mints go to the developer
      _mint(developer, 1);
    } else {
      // the rest goes to the owner for distribution
      _mint(owner(), 1);
    }
  }

  function _isPrimary(uint256 _tokenId) internal view returns(bool) {
    return _tokenId % tokensPerAsset == 0;
  }

  function generateTraits(uint256 _tokenId) internal view override returns (bytes memory) {
    return abi.encodePacked(
      '{'
        '"trait_type":"Primary",'
        '"value":"', _isPrimary(_tokenId) ? 'Yes':'No', '"' 
      '}'
    );
  }
}