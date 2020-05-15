console.log('loaded')

function setupStripe () {
  const src = 'https://js.stripe.com/v3/'
  const key = document.querySelector('[name="stripe_public_key"]').content

  if (window.StripeInstance != null) {
    return window.StripeInstance
  }

  let el = document.querySelector(`[src="${src}"]`)

  if (el == null) {
    el = document.createElement('script')
    el.src = src
    el.async = true

    document.head.appendChild(el)
  }

  return new Promise((resolve, reject) => {
    el.addEventListener('load', () => {
      window.StripeInstance = window.Stripe(key)
      return resolve(window.StripeInstance)
    })

    el.addEventListener('error', (err) => {
      return reject(err)
    })
  })
}

async function doStripeLogic () {
  await setupStripe()
  console.log('stripe loaded')
}

window.addEventListener('phx:page-loading-stop', info => {
  const paymentMeta = document.querySelector('[name="payment_service"]')
  const service = (paymentMeta != null) ? paymentMeta.content : null

  switch (service) {
    case 'stripe':
      doStripeLogic()
  }
})
