# Not work

$loginPage = Invoke-WebRequest -Uri 'https://yande.re/user/login' -SessionVariable $yandeSession

$loginRequestParams = @{ authenticity_token = $loginPage.Forms[9].Fields.authenticity_token;
                         'user[name]' = '890508'; 'user[password]' = '890508'; commit = 'Login' }

$authenticate = Invoke-WebRequest -Uri 'https://yande.re/user/authenticate' -Method Post -ContentType 'application/x-www-form-urlencoded' `
                                  -Body $loginRequestParams -WebSession $yandeSession `
                                  -OutFile Z:\tempHtml.html

$request = Invoke-WebRequest -Uri 'https://yande.re/pool/zip/5046?jpeg=1' -WebSession $yandeSession -OutFile Z:\tempHtml.html
