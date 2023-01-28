local ht = require('haskell-tools')
local stub = require('luassert.stub')
local deps = require('haskell-tools.deps')

local hoogle_web = require('haskell-tools.hoogle.web')
local hoogle_local = require('haskell-tools.hoogle.local')
local web_telescope_search = stub(hoogle_web, 'telescope_search')
local browser_search = stub(hoogle_web, 'browser_search')
local local_telescope_search = stub(hoogle_local, 'telescope_search')

describe('Hoogle:', function()
  ht.setup {}
  it('Hoogle API available after setup', function()
    assert(ht.hoogle ~= nil)
  end)
  if hoogle_local.has_hoogle() then
    if deps.has_telescope() then
      it('Defaults to local handler', function()
        pcall(ht.hoogle.hoogle_signature, { search_term = 'foo' })
        assert.stub(local_telescope_search).was_called()
      end)
    else
      it('Defaults to web handler with browser search', function()
        pcall(ht.hoogle.hoogle_signature, { search_term = 'foo' })
        assert.stub(browser_search).was_called()
      end)
    end
  else
    if deps.has_telescope() then
      it('Defaults to web handler with telescope search', function()
        pcall(ht.hoogle.hoogle_signature, { search_term = 'foo' })
        assert.stub(web_telescope_search).was_called()
      end)
    else
      it('Web handler is available', function()
        assert(hoogle_web.browser_search ~= nil)
      end)
      it('Defaults to web handler with browser search', function()
        pcall(ht.hoogle.hoogle_signature, { search_term = 'foo' })
        assert.stub(browser_search).was_called()
      end)
    end
  end
end)